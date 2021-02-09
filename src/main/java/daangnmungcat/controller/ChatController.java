package daangnmungcat.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import daangnmungcat.dto.AuthInfo;
import daangnmungcat.dto.Chat;
import daangnmungcat.dto.ChatMessage;
import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.Member;
import daangnmungcat.dto.Sale;
import daangnmungcat.exception.AlreadySoldOut;
import daangnmungcat.service.ChatService;
import daangnmungcat.service.JoongoSaleReviewService;
import daangnmungcat.service.JoongoSaleService;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
public class ChatController {

	@Autowired
	private ChatService chatService;
	
	@Autowired
	private JoongoSaleService saleService;
	
	@Autowired
	private JoongoSaleReviewService reviewService;
	
	@GetMapping("/chat")
	public String myChatList(Model model, HttpSession session) {
		AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
		log.debug("loginUser's ID: " + loginUser.getId());
		
		List<Chat> list = chatService.getMyChatsList(loginUser.getId());
		list.stream().forEach(chat -> log.debug(chat.toString()));
		model.addAttribute("list", list);
		
		return "/chat/mychats";
	}
	
	@GetMapping("/chat/sale/{id}")
	public String myChatList(@PathVariable("id") int id, Model model, HttpSession session) {
		AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
		log.debug("loginUser's ID: " + loginUser.getId());
		
		List<Chat> list = chatService.getMyChatsList(id);
		list.stream().forEach(chat -> log.debug(chat.toString()));
		model.addAttribute("list", list);
		
		return "/chat/mychats";
	}
	
	
	@GetMapping("/chat/{id}")
	public String chatView(@PathVariable("id") int id, Model model, HttpSession session) {
		AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
		
		chatService.readChat(id, loginUser.getId());
		
		Criteria cri = new Criteria(1, 20);
		Chat chat = chatService.getChatWithMessages(id, cri);
		log.debug("chat: " + chat.toString());
		
		if(reviewService.selectJoongoReviewBySaleId(chat.getSale().getId()) != null) {
			model.addAttribute("reviewed", true);
		}
		
		model.addAttribute("chat", chat);
		
		return "/chat/room";
	}
	
	@ResponseBody
	@GetMapping("/api/chat/message")
	public List<ChatMessage> chatList(@RequestParam(value = "id", required = true) int chatId, @RequestParam(value = "page", defaultValue = "1") int page, HttpSession session) {
		AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
		
		Criteria criteria = new Criteria(page, 20);
		chatService.getChatMessages(chatId, criteria);
		List<ChatMessage> list = chatService.getChatMessages(chatId, criteria);
		
		return list;
	}
	
	
	@GetMapping("/go-to-chat")
	public String goToChatFromSale(@RequestParam(value = "id") int saleId, HttpSession session, RedirectAttributes redirectAttributes, Model model) {
		
		Sale sale = null;
		String loginUserId = null;

		// 로그아웃 상태이거나 해당 글이 없는 경우
		try {
			AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
			loginUserId = loginUser.getId();
			sale = saleService.getSaleById(saleId);
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/joongo_list";
		}
		
		// 본인이 작성한 글에 접근했을 때
		if(sale.getMember().getId().equals(loginUserId)) {
			return "redirect:/chat/sale/" + saleId;
		}
		
		Chat chat = chatService.getChatInfoFromSale(loginUserId, saleId);
		// 기존의 채팅이 있는 경우 해당 채팅방으로 이동
		if(chat != null) {
			return "redirect:/chat/" + chat.getId();
		}
		
		model.addAttribute("sale", sale);
		return "/chat/new_room";
	}
	
	
	@PostMapping("/chat/room")
	@ResponseBody
	public ResponseEntity<Object> createNewRoom(@RequestBody Sale sale, HttpSession session) {
		
		// #{id}, #{sale.id}, #{sale.member.id}, #{buyer.id}
		Member buyer = null;
		int chatId = 0;
		
		try {
			AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
			buyer = new Member(loginUser.getId());
			Chat chat = new Chat(sale, buyer);
			log.debug(chat.toString());
			
			chatId = chatService.createNewChat(chat);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
		
		return ResponseEntity.ok(chatId);
	}
	
	@PostMapping("/chat/{id}/upload")
	@ResponseBody
	public ResponseEntity<Object> uploadImageFile(@PathVariable(value = "id") int id, @RequestParam(value="imageFile") MultipartFile file, ChatMessage message, HttpSession session) {
		System.out.println(">> uploadImageFile()");
		String fileName = null;
		
		try {
			AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
			message.setChat(new Chat(id));
			fileName = chatService.uploadImageMessage(message, file, session);
		} catch(Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
		
		return ResponseEntity.ok(fileName);
	}
	
	
	@PostMapping("/chat/{id}/sold-out")
	public ResponseEntity<Object> soldOut(@PathVariable(value = "id") int id, HttpServletRequest request) {
		int res = 0;
		try {
			String loginUser = ((AuthInfo) request.getSession().getAttribute("loginUser")).getId();
			Chat chat = chatService.getChatInfo(id);
			if(!loginUser.equals(chat.getSale().getMember().getId()) && !loginUser.equals(chat.getBuyer().getId())) {
				return ResponseEntity.status(HttpStatus.CONFLICT).body("해당 채팅의 참여자가 아닙니다.");
			}
			res = saleService.soldOut(chat.getBuyer(), chat.getSale());
		} catch (AlreadySoldOut so) {
			return ResponseEntity.status(HttpStatus.CONFLICT).body(so.getMessage());
		}
		
		return ResponseEntity.ok(res);
	}
	
}

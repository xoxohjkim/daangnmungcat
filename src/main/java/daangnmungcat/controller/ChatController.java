package daangnmungcat.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ChatController {

	// 채팅방 입장
	@RequestMapping(value = "/chat", method = RequestMethod.GET)
	public String view_chat(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		return "view_chat";
	}
}
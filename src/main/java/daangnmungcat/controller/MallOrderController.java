package daangnmungcat.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import daangnmungcat.dto.AuthInfo;
import daangnmungcat.dto.Cart;
import daangnmungcat.dto.MallProduct;
import daangnmungcat.dto.Member;
import daangnmungcat.service.CartService;
import daangnmungcat.service.MallPdtService;
import daangnmungcat.service.MemberService;

@RestController
public class MallOrderController {
	
	@Autowired
	private MemberService service;
	
	@Autowired
	private MallPdtService mService;
	
	@Autowired
	private CartService cartService;
	
	@PostMapping("/pre-order")
	public void orderCheck(@RequestBody Map<String, Object> map, HttpSession session, HttpServletRequest request) {
		session = request.getSession();
		AuthInfo info = (AuthInfo) session.getAttribute("loginUser");
		Member loginUser = service.selectMemberById(info.getId());
		session.setAttribute("total", map.get("total_price"));
		session.setAttribute("qtt", map.get("quantity"));
		MallProduct pdt = mService.getProductById(Integer.parseInt(map.get("m_id").toString()));
		session.setAttribute("pdt", pdt);
		
		// 카트 세션에 set X DB 이용 중
	}
	
	@GetMapping("/pre-order")
	public String orderPage(Model model, Cart[] cartList, HttpSession session, HttpServletRequest request) {
		session = request.getSession();
		AuthInfo info = (AuthInfo) session.getAttribute("loginUser");
		Member loginUser = service.selectMemberById(info.getId());
		System.out.println(cartList);
		
		List<Cart> list = new ArrayList<>();
		for(Cart cart : cartList) {
			Cart cartItem = cartService.getCartItem(cart.getId());
			list.add(cartItem);
		}
		
		return "/mall_pre_order";
	}
	
	/*	@GetMapping("/pre-order")
		public void orderPage(HttpSession session, HttpServletRequest request) {
			session = request.getSession();
			AuthInfo info = (AuthInfo) session.getAttribute("loginUser");
			Member loginUser = service.selectMemberById(info.getId());
			String total = (String) session.getAttribute("total");
			String qtt = (String) session.getAttribute("qtt");
			int pdtId = (int) session.getAttribute("pdt");
			System.out.println("총: "+ total + "/ 수량: "+ qtt + "/ 제품id" +  pdtId);
		}
	*/	
	

}

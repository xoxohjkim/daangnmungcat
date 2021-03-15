package daangnmungcat.controller.admin;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import daangnmungcat.dto.Cart;
import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.Order;
import daangnmungcat.dto.OrderDetail;
import daangnmungcat.dto.OrderState;
import daangnmungcat.dto.PageMaker;
import daangnmungcat.dto.Payment;
import daangnmungcat.dto.kakao.KakaoPayApprovalVO;
import daangnmungcat.service.KakaoPayService;
import daangnmungcat.service.MemberService;
import daangnmungcat.service.OrderService;
import lombok.extern.log4j.Log4j2;

@Controller
@RestController
@Log4j2
public class AdminOrderController {
	
	@Autowired
	private OrderService orderService;
	
	@Autowired
	private KakaoPayService kakaoService;
	
	@Autowired
	private MemberService memberService;
	
	@GetMapping("/admin/order/list")
	public ModelAndView orderList(Criteria cri, 
			@Nullable @RequestParam String search, @Nullable @RequestParam String query,
			@Nullable @RequestParam String start, @Nullable @RequestParam String end,
			@Nullable @RequestParam String state,@Nullable @RequestParam String part_cancel,
			@Nullable @RequestParam String settle_case,
			@Nullable @RequestParam String misu, @Nullable @RequestParam String return_price) {
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		cri.setPerPageNum(10);
		List<Order> list = null;

		
		if(search != null  || query != null) {

			list = orderService.selectOrderBySearch(search, query, state,  start, end, settle_case, part_cancel, misu, return_price, cri);
			pageMaker.setTotalCount(orderService.searchListCount(search, query, state, start, end, part_cancel, settle_case, misu, return_price));
			System.out.println(orderService.searchListCount(search, query, state, start, end, settle_case, part_cancel, misu, return_price));
			
		}else if(state != null ||  start != null || end != null || settle_case != null || 
				part_cancel != null || misu != null || return_price != null) {
			
			if(state.equals("전체")) {
				state = "";
			}
			if(state.equals("전체취소")) {
				state = "취소";
			}
			if(state.equals("부분취소")) {
				state = null; 
			}
			
			if(settle_case.equals("전체")) {
				settle_case = null;
			}
			
			list = orderService.selectOrderBySearch(search, query, state,  start, end, settle_case, part_cancel, misu, return_price, cri);
			pageMaker.setTotalCount(orderService.searchListCount(search, query, state, start, end, part_cancel, settle_case, misu, return_price));
			System.out.println("총갯수:" + orderService.searchListCount(search, query, state, start, end, part_cancel, settle_case, misu, return_price));
		}else {
			list = orderService.selectOrderAll(cri);
			pageMaker.setTotalCount(orderService.listCount());
			System.out.println(orderService.listCount());
		}
		
		for(Order o: list) {
			List<OrderDetail> odList = orderService.sortingOrderDetail(o.getId());
			o.setDetails(odList);
			for(OrderDetail od: odList) {
				od.setOrderId(o.getId());
			}
		}
		
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("totalCnt", orderService.listCount());
		mv.addObject("list", list);
		mv.addObject("pageMaker", pageMaker);
		mv.addObject("content", search);
		mv.addObject("query", query);
		mv.addObject("state", state);
		mv.addObject("start", start);
		mv.addObject("end", end);
		mv.addObject("settleCase", settle_case);
		mv.addObject("partCancel", part_cancel);
		mv.addObject("misu", misu);
		mv.addObject("returnPrice", return_price);
	
		mv.setViewName("/admin/order/order_list");
		
		return mv;
	}
	
	@GetMapping("/admin/order")
	public ModelAndView orderList(@RequestParam String id) {
		
		Order order = orderService.getOrderByNo(id);
		List<OrderDetail> odList = orderService.sortingOrderDetail(order.getId());
		order.setDetails(odList);
		for(OrderDetail od: odList) {
			od.setOrderId(order.getId());
		}
		
		KakaoPayApprovalVO kakao = null;
		Payment pay = null;
		
		if(order.getSettleCase().equals("카카오페이")) {
			kakao = kakaoService.kakaoPayInfo(order.getPayId());
			pay = orderService.selectAccountPaymentByOrderId(order.getId());
			System.out.println("kakao: " + kakao);
		}else {
			pay = orderService.selectAccountPaymentByOrderId(order.getId());
		}
		
		//결제완료인 물품만 다시 계산
		List<OrderDetail> partList = orderService.selectOrderDetailUsingPartCancelByOrderId(order.getId());
		List<Cart> cartList = new ArrayList<Cart>();
		for(OrderDetail od: odList) {
			Cart cart = new Cart();
			cart.setMember(order.getMember());
			cart.setProduct(od.getPdt());
			cart.setQuantity(od.getQuantity());
			cartList.add(cart);
		}
		
		
		Map<String, Integer> map = orderService.calculateDeliveryFee(cartList);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("part", partList);
		mv.addObject("pay", pay);
		mv.addObject("kakao", kakao);
		mv.addObject("order", order);
		
		mv.addObject("total", map.get("total"));
		mv.addObject("conditional", map.get("conditional"));
		mv.addObject("charged", map.get("charged"));
		mv.setViewName("/admin/order/order_detail");
		
		return mv;
	}
	
	@ResponseBody
	@PostMapping("/admin/order/{status}")
	public int updateOrderState(@RequestBody String[] od, @PathVariable String status, HttpServletRequest request){
		
		//od id list
		Order order = null;
		int res = 0;
		Payment pay = null;
		System.out.println("status:" + status);
		for(int i=0; i<od.length; i++) {
			
			OrderDetail ord = orderService.getOrderDetailById(od[i]);
			order = orderService.getOrderByNo(ord.getOrderId());
			List<OrderDetail> odList = orderService.getOrderDetail(ord.getOrderId());
			pay = orderService.selectAccountPaymentByOrderId(order.getId());
			
			//품절상태에서 다른 상태로 되돌리면 복구
			
			if(!status.equals(OrderState.SOLD_OUT.getLabel()) && 
					!status.equals(OrderState.CANCEL.getLabel()) &&
					!status.equals(OrderState.RETURN.getLabel())) {
					
			//대기, 결제, 배송, 완료는 하나라도 변경 시 order도 변경
			
				if(!ord.getOrderState().getLabel().equals(OrderState.DEPOSIT_REQUEST.getLabel()) 
						&& !ord.getOrderState().getLabel().equals(OrderState.PAID.getLabel()) 
						&& !ord.getOrderState().getLabel().equals(OrderState.SHIPPING.getLabel()) 
						&& !ord.getOrderState().getLabel().equals(OrderState.DELIVERED.getLabel())){
						
						if(status.equals("대기")) {
							ord.setOrderState(OrderState.DEPOSIT_REQUEST);
							order.setState(OrderState.DEPOSIT_REQUEST.getLabel());
		
						}else if(status.equals("결제")) {
							ord.setOrderState(OrderState.PAID);
							order.setState(OrderState.PAID.getLabel());
			
						}else if(status.equals("배송")) {
							ord.setOrderState(OrderState.SHIPPING);
							order.setState(OrderState.SHIPPING.getLabel());
				
						}else if(status.equals("완료")) {
							ord.setOrderState(OrderState.DELIVERED);
							order.setState(OrderState.DELIVERED.getLabel());
						}
						

						if(order.getPayId() == null) {
							System.out.println("pay 없음");
							System.out.println(ord);
							//현재 51000. return = 0 + 33000취소
							//order.setReturnPrice(order.getReturnPrice() + ord.getTotalPrice());
							//order.setMisu(order.getFinalPrice() - order.getReturnPrice());
							//미수 = 51000 - 33000 + 0 = 18000
							
							//33000 - 33000 = 0
							order.setReturnPrice(order.getReturnPrice() - ord.getTotalPrice());
							order.setMisu(order.getFinalPrice() - order.getReturnPrice()); 
							
							//54000 - 0
						
						}else {
							order.setReturnPrice(ord.getTotalPrice());
							order.setMisu(order.getFinalPrice() - order.getReturnPrice() + order.getCancelPrice() - pay.getPayPrice());
						}
						
						orderService.updatePartOrderDetail(ord, ord.getId());
						orderService.updateOrder(order, order.getId());
						
						
				} else {
						
					if(status.equals("대기")) {
						ord.setOrderState(OrderState.DEPOSIT_REQUEST);
						order.setState(OrderState.DEPOSIT_REQUEST.getLabel());
	
					}else if(status.equals("결제")) {
						ord.setOrderState(OrderState.PAID);
						order.setState(OrderState.PAID.getLabel());
		
					}else if(status.equals("배송")) {
						ord.setOrderState(OrderState.SHIPPING);
						order.setState(OrderState.SHIPPING.getLabel());
			
					}else if(status.equals("완료")) {
						ord.setOrderState(OrderState.DELIVERED);
						order.setState(OrderState.DELIVERED.getLabel());
					}
					
					orderService.updatePartOrderDetail(ord, ord.getId());
					orderService.updateOrder(order, order.getId());
				}
				
					
				
					
					
			//취소, 반품, 품절일때 -> 상세 각자 상태변경
			//대기 상태에서 변경 order 미수금에서 해당 상품 금액 빼기
			//입금 상태에서 품절 시 전체금액 - 해당상품금액 -> 미수금 마이너스됨 -> 취소/환불금액에서 입력하면 처리
			//주문 총액은 변경 x 미수만 변경	
			//반품,품절금액 -> return_price에 반영 
			//결제 취소 금액 -> cancel_price. 최종미수금에서 + 
				
			//무통장일때 pay가 존재하지 않으면 미수도 0
				
			} else { 
				
				//취소반품 품절일때 중복 변경 x
				if(!ord.getOrderState().getLabel().equals(OrderState.CANCEL.getLabel()) 
						&& !ord.getOrderState().getLabel().equals(OrderState.RETURN.getLabel()) 
						&& !ord.getOrderState().getLabel().equals(OrderState.SOLD_OUT.getLabel())){
					
					if(status.equals("취소")) {
						ord.setOrderState(OrderState.CANCEL);
					}else if(status.equals("반품")) {
						ord.setOrderState(OrderState.RETURN);	
					}else if(status.equals("품절")) {
						ord.setOrderState(OrderState.SOLD_OUT);
					}

					if(order.getPayId() == null) {
						System.out.println("pay 없음");
						
						// 무통장시 미수금 있음 지금 미수에서 -> 취소시 해당 ord의 total 빼기
						//현재 51000. return = 0 + 33000취소
						order.setReturnPrice(order.getReturnPrice() + ord.getTotalPrice());
						order.setMisu(order.getFinalPrice() - order.getReturnPrice());
						//미수 = 51000 - 33000 + 0 = 18000
						
						//대기,결제
						//order.setReturnPrice(order.getReturnPrice() - ord.getTotalPrice());
						//order.setMisu(order.getFinalPrice() - order.getReturnPrice()); 
					
					}else {
						//주문취소에 추가  => 현재 취소액 + 선택한 금액
						order.setReturnPrice(order.getReturnPrice() + ord.getTotalPrice());
						order.setMisu(order.getFinalPrice() - order.getReturnPrice() + order.getCancelPrice() + pay.getPayPrice());
					}
					
				}else {
					System.out.println("취반품");
					System.out.println(status + " - " + ord.getOrderState().getLabel());
					if(status.equals("취소")) {
						ord.setOrderState(OrderState.CANCEL);
					}else if(status.equals("반품")) {
						ord.setOrderState(OrderState.RETURN);	
					}else if(status.equals("품절")) {
						ord.setOrderState(OrderState.SOLD_OUT);
					}

				}

				orderService.updatePartOrderDetail(ord, ord.getId());
				orderService.updateOrder(order, order.getId());
				
			}
				
			
			if(odList.size() == od.length) {
				// 전체선택 ->  order의 상태도 같이 변경
				// 하나라도 있으면 유지
				// 하나 취소 -> 상태유지
				order.setState(status);
				orderService.updateOrder(order, order.getId());
			}
			
	
		} //end
		
		//모든 처리 후 현재 모든 status가 동일하면 order도 같이 변경
		
		List<OrderDetail> odList = null;
		for(int i=0; i<od.length; i++) {
			OrderDetail ord = orderService.getOrderDetailById(od[i]);
			odList = orderService.getOrderDetail(ord.getOrderId());
			order = orderService.getOrderByNo(ord.getOrderId());
			
			int j = 0;
			for(i=0; i<odList.size(); i++) {
				if(odList.get(i).getOrderState().getLabel().equals(status)) {
					j++;
				}
			}
			if(j == odList.size()) {
				order.setState(status);
				orderService.updateOrder(order, order.getId());
			}
			
		}
		
		//최종 미수: 품절 아닌 odList의 가격 - 입금액
		int deposit = 0;
		int pdtPrice = 0;
		
		List<OrderDetail> notSoldOutList = orderService.selectNotSoldOutOrderDetailById(order.getId());
		
		if(pay == null) {
			deposit = 0;
			for(OrderDetail notSoldOutOd: notSoldOutList) {
				pdtPrice += notSoldOutOd.getPdt().getPrice() * notSoldOutOd.getQuantity();
			}
			
		}else {
			deposit = pay.getPayPrice();
			for(OrderDetail notSoldOutOd: notSoldOutList) {
				pdtPrice += notSoldOutOd.getPdt().getPrice() * notSoldOutOd.getQuantity();
			}
			System.out.println(pdtPrice);
		}
		
		//최종 = 품절아닌 상품금액 - 입금액 + 취소/환불 금액
		int finalPrice = pdtPrice - deposit;
//		System.out.println("품절아닌상품금액:" + finalPrice);
//		System.out.println("입금액:" + pay.getPayPrice());
//		System.out.println("환불금액:" + order.getCancelPrice());
//		System.out.println("주문취소:" + order.getReturnPrice());
//		System.out.println("return price + 품절아닌 odList의 가격 : " + (finalPrice - order.getReturnPrice()));
		
//		order.setMisu(finalPrice - order.getReturnPrice());
//		orderService.updateOrder(order, order.getId());			
		
		return res;
	}
	
	@ResponseBody
	@PostMapping("/admin/order/post")
	public ResponseEntity<Object> updateOrder(@RequestBody Map<String, String> map){
		
		try {
			return ResponseEntity.ok(orderService.adminInsertPaymentAndOrderUpdate(map));
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
		
	}
	
	
	@PostMapping("/admin/shipping/post")
	public ResponseEntity<Object> updatesOrderShipping(@RequestBody Map<String, String> map){
		System.out.println("shipping update");
		try {
			
			String id = map.get("id");
			String name =  map.get("name");
			String zipcode =  map.get("zipcode");
			String add1 = map.get("add1");
			String add2 =  map.get("add2");
			String phone1 =  map.get("phone1");
			String phone2 =  map.get("phone2");
			String memo =  map.get("memo");
			
			Order o = orderService.getOrderByNo(id);
			
			o.setAddName(name);
			o.setZipcode(Integer.parseInt(zipcode));
			o.setAddress1(add1);
			o.setAddress2(add2);
			o.setAddPhone1(phone1);
			o.setAddPhone2(phone2);
			o.setAddMemo(memo);
			
			return ResponseEntity.ok(orderService.updateOrder(o, o.getId()));
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
		
	}
	
	@GetMapping("/admin/order/part_cancel")
	public ModelAndView partCancel(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		String oid = request.getParameter("oid");
		String tid = request.getParameter("tid");
		
		Order order = orderService.getOrderByNo(oid);
		KakaoPayApprovalVO kakao = kakaoService.kakaoPayInfo(tid);
		
		mv.addObject("order", order);
		mv.addObject("kakao", kakao);
		mv.setViewName("/admin/order/part_cancel");
		
		return mv;
		
	}
	
	@PostMapping("/kakao-part")
	public String kakaoPartCancel(@RequestBody Map<String, String> map) {
		log.info("kakao- part cancel - post");
		return "redirect:" + kakaoService.kakaoPayPartCancel(map);
	}
	
	
}

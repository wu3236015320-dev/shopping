package com.hjp.shop.Interceptor;

import javax.servlet.http.HttpServletRequest;

import com.hjp.shop.model.User;
import com.jfinal.aop.Interceptor;
import com.jfinal.core.ActionInvocation;
import com.jfinal.core.Controller;

/**
 * 购买、购物车、下单等操作需登录；未登录则保存当前请求 URL 并跳转到前台登录页。
 * 管理员与普通用户均需先登录，再根据 AdminInterceptor 区分后台权限。
 */
public class LoginRequiredInterceptor implements Interceptor {
	public static final String REDIRECT_AFTER_LOGIN = "redirectAfterLogin";

	@Override
	public void intercept(ActionInvocation ai) {
		Controller ctrl = ai.getController();
		User user = (User) ctrl.getSessionAttr("user");
		if (user != null) {
			ai.invoke();
			return;
		}
		HttpServletRequest req = ctrl.getRequest();
		String uri = req.getRequestURI();
		String qs = req.getQueryString();
		if (qs != null && !qs.isEmpty()) {
			uri = uri + "?" + qs;
		}
		ctrl.setSessionAttr(REDIRECT_AFTER_LOGIN, uri);
		ctrl.redirect("/user/login");
	}
}

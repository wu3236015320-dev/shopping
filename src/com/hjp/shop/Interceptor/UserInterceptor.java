package com.hjp.shop.Interceptor;

import com.hjp.shop.model.User;
import com.jfinal.aop.Interceptor;
import com.jfinal.core.ActionInvocation;

public class UserInterceptor implements Interceptor {
	public void intercept(ActionInvocation ai) {
		User user = (User) ai.getController().getSessionAttr("user");
		if (user != null) {
			if (User.dao.verify(user.getStr("username")).equals("no")) {
				ai.invoke();
			} else {
				ai.getController().redirect("/index.html");
			}
		} else {
			// 未登录访问需登录的 /user/* 时，保存当前地址并跳转到登录页
			ai.getController().setSessionAttr(LoginRequiredInterceptor.REDIRECT_AFTER_LOGIN,
					ai.getController().getRequest().getRequestURI());
			ai.getController().redirect("/user/login");
		}
	}
}

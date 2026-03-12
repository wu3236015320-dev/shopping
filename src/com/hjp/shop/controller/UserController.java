package com.hjp.shop.controller;

import java.util.Date;

import com.hjp.shop.Interceptor.AdminInterceptor;
import com.hjp.shop.Interceptor.UserInterceptor;
import com.hjp.shop.model.User;
import com.jfinal.aop.Before;
import com.jfinal.aop.ClearInterceptor;
import com.jfinal.core.Controller;

@Before(UserInterceptor.class)
public class UserController extends Controller {

	@ClearInterceptor
	public void index() {
		renderHtml("<div class='span3 offset4'><h1>Hello,welcome you</h1></div>");
	}

	@ClearInterceptor
	public void register() {

		if (getPara("reg") != null && getPara("reg").equals("ok")) {
			String username = this.getPara("username");
			String password = this.getPara("password");
			String phone = this.getPara("phone");
			String addr = this.getPara("addr");
			password = User.EncoderByMd5(password);
			boolean isSave = new User().set("username", username)
					.set("password", password).set("phone", phone)
					.set("addr", addr).set("rdate", new Date()).save();
			if (isSave) {
				this.setAttr("reg", "yes");
				redirect("/");
			}
		} else {
			this.render("register.html");
		}
	}

	/** 仅管理员可删除用户（后台用户管理用） */
	@Before(AdminInterceptor.class)
	public void delete() {
		User.dao.deleteById(getParaToInt());
		redirect("/admin/listUser");
	}

	public void selfServer() {
		User user = (User) getSessionAttr("user");
		setAttr("user", user);
		setAttr("msg", getPara("msg"));
		render("/user/selfServer.html");
	}

	@ClearInterceptor
	public void verify() {
		String username = getPara("name");
		renderText(User.dao.verify(username));
	}

	@ClearInterceptor
	public void login() {
		if (getPara("login") != null && getPara("login").equals("ok")) {
			String usernameString = getPara("username");
			String passwordString = getPara("password");
			passwordString = User.EncoderByMd5(passwordString);
			if (passwordString.equals(User.dao.getPasswordByusername(usernameString))) {
				this.setSessionAttr("user", User.dao.getUserByName(usernameString));
				String redirect = (String) getSessionAttr(com.hjp.shop.Interceptor.LoginRequiredInterceptor.REDIRECT_AFTER_LOGIN);
				if (redirect != null) {
					removeSessionAttr(com.hjp.shop.Interceptor.LoginRequiredInterceptor.REDIRECT_AFTER_LOGIN);
					redirect(redirect);
					return;
				}
				String path = (String) getSessionAttr("path");
				if (path != null) {
					redirect(path);
					return;
				}
				redirect("/");
				return;
			} 
		}
		String path = getRequest().getHeader("referer");
		setSessionAttr("path", path);
		setAttr("loginRequired", getSessionAttr(com.hjp.shop.Interceptor.LoginRequiredInterceptor.REDIRECT_AFTER_LOGIN) != null);
		render("/user/login.html");
	}

	public void userinfo() {
		String info = this.getPara(0);
		User user = (User) getSessionAttr("user");
		setAttr("user", user);
		if (info.equals("info"))
			render("/user/userinfo.html");
		else if (info.equals("update"))
			render("/user/userUpdate.html");
		else if (info.equals("updatePassword"))
			render("/user/updatePassword.html");
	}

	public void update() {
		User user = (User) getSessionAttr("user");
		String phone = getPara("phone");
		String addr = getPara("addr");
		if (phone == null || addr == null) {
			redirect("/user/selfServer?msg=phone_addr_required");
			return;
		}
		user.set("phone", phone);
		user.set("addr", addr);
		if (!user.update()) {
			redirect("/user/selfServer?msg=update_fail");
			return;
		}
		redirect("/user/selfServer?msg=update_ok");
	}

	public void updatePassword() {
		User user = (User) getSessionAttr("user");
		String password = getPara("password");
		String password1 = getPara("password1");
		String password2 = getPara("password2");

		if (password == null || !User.EncoderByMd5(password).equals(user.get("password"))) {
			redirect("/user/selfServer?msg=pwd_old_wrong");
			return;
		}
		if (password1 != null && password1.equals(password2)) {
			user.set("password", User.EncoderByMd5(password1));
			if (user.update()) {
				redirect("/user/selfServer?msg=pwd_ok");
				return;
			}
			redirect("/user/selfServer?msg=pwd_fail");
			return;
		}
		redirect("/user/selfServer?msg=pwd_mismatch");
	}
	public void logout(){
		setSessionAttr("user", null);
		redirect("/");
	}
}

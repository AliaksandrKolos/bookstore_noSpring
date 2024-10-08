package com.kolos.bookstore.controller;

import com.kolos.bookstore.controller.command.Command;
import com.kolos.bookstore.controller.command.CommandFactory;
import com.kolos.bookstore.service.exception.DuplicateEmailException;
import com.kolos.bookstore.service.exception.InvalidOrderStatusTransitionException;
import com.kolos.bookstore.service.exception.NotFoundException;
import com.kolos.bookstore.service.exception.UserInputValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;


@Slf4j
@WebServlet("/controller")
public class FrontController extends HttpServlet {

    private CommandFactory commandFactory;

    private void process(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String command = req.getParameter("command");
            Command commandInstance = commandFactory.getCommand(command);
            String page = commandInstance.process(req);
            req.getRequestDispatcher(page).forward(req, resp);
        } catch (UserInputValidationException e) {
            req.setAttribute("dataError", e.getErrorMessages());
            req.getRequestDispatcher("jsp/user/userRegistrationForm.jsp").forward(req, resp);
        } catch (InvalidOrderStatusTransitionException e) {
            req.setAttribute("dataError", e.getMessage());
            req.getRequestDispatcher("jsp/order/orders.jsp").forward(req, resp);
        } catch (DuplicateEmailException e) {
            req.setAttribute("dataError", e.getMessage());
            req.getRequestDispatcher("jsp/user/userRegistrationForm.jsp").forward(req, resp);
        } catch (NotFoundException e) {
            req.setAttribute("dataError", e.getMessage());
            req.getRequestDispatcher("jsp/user/users.jsp").forward(req, resp);
        } catch (Exception e) {
            Command commandInstance = commandFactory.getCommand("error");
            String page = commandInstance.process(req);
            req.getRequestDispatcher(page).forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        process(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        process(req, resp);
    }

    @Override
    public void destroy() {
        if (commandFactory != null) {
            commandFactory.shatdown();
        }
        log.info("Controller destroyed");
    }

    @Override
    public void init() {
        commandFactory = CommandFactory.getInstance();
        log.info("Controller initialized");
    }
}

package org.blockchain.borrowing.web;

import com.google.gson.Gson;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * 异常拦截
 *
 * Created by pengchangguo on 16/1/9.
 */

@Component
public class ExceptionResolver extends SimpleMappingExceptionResolver {

    private static Logger logger = Logger.getLogger(ExceptionResolver.class);

    @Override
    protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        logger.error(String.format("执行错误 %s : %s", request.getRequestURL(), new Gson().toJson(request.getParameterMap())), ex);
        response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control","no-cache, must-revalidate");
        try {
            response.getWriter().write("{\"error\":\"" + ex.getMessage() + "\"}");
            return new ModelAndView();
        } catch (IOException e) {
            logger.error("response error!", e);
            return super.doResolveException(request, response, handler, ex);
        }
    }
}

<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test="${sessionScope.lang != null}">
    <fmt:setBundle basename="messages"/>
    <fmt:setLocale value="${sessionScope.lang}"/>
</c:if>
<c:if test="${sessionScope.lang == 'ru'}">
    <fmt:setBundle basename="messages_ru"/>
    <fmt:setLocale value="ru"/>
</c:if>
<c:if test="${sessionScope.lang == 'de'}">
    <fmt:setBundle basename="messages_de"/>
    <fmt:setLocale value="de"/>
</c:if>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <title><fmt:message key="books.title"/></title>
</head>
<body>
<jsp:include page="../navbar.jsp"/>
<h1><fmt:message key="books.header"/></h1>

<c:if test="${books == null || books.isEmpty()}">
    <h2><fmt:message key="books.no_books"/></h2>
</c:if>

<c:if test="${books != null && !books.isEmpty()}">
    <form method="get" action="controller">
        <input type="text" placeholder="<fmt:message key='books.search'/>" name="search" value="${param.search}" />
        <input type="hidden" name="command" value="books_search" />
        <input type="hidden" name="page" value="${param.page != null ? param.page : 1}" />
        <input type="hidden" name="page_size" value="${param.page_size != null ? param.page_size : 5}" />

        <button type="submit" class="btn"><fmt:message key="books.search"/></button>
    </form>

    <div class="pagination">
        <!-- Кнопка "First" -->
        <a href="controller?command=books_search&page=1&page_size=${param.page_size}&search=${param.search}">
            <fmt:message key="books.first"/>
        </a>

        <!-- Кнопка "Prev" -->
        <a href="controller?command=books_search&page=${page <= 1 ? 1 : page - 1}&page_size=${param.page_size}&search=${param.search}">
            <fmt:message key="books.prev"/>
        </a>

        <!-- Текущая страница -->
        <c:out value="${page}"/>

        <!-- Кнопка "Next" -->
        <a href="controller?command=books_search&page=${page < totalPages ? page + 1 : totalPages}&page_size=${param.page_size}&search=${param.search}">
            <fmt:message key="books.next"/>
        </a>


        <!-- Кнопка "Last" -->
        <a href="controller?command=books_search&page=${totalPages}&page_size=${param.page_size}&search=${param.search}">
            <fmt:message key="books.last"/>
        </a>
    </div>

    <table>
        <thead>
        <tr>
            <th><fmt:message key="books.id"/></th>
            <th><fmt:message key="books.title_book"/></th>
            <th><fmt:message key="books.author"/></th>
            <c:if test="${sessionScope.user.role eq 'MANAGER' || sessionScope.user.role eq 'ADMIN'}">
                <th><fmt:message key="books.action"/></th>
                <th><fmt:message key="books.action"/></th>
            </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${books}" var="book">
            <tr>
                <td><c:out value="${book.id}"/></td>
                <td><a href="controller?command=book&id=<c:out value="${book.id}"/>"><c:out value="${book.title}"/></a></td>
                <td><c:out value="${book.author}"/></td>
                <td>
                    <form method="post" action="${pageContext.request.contextPath}/controller?command=addToCart" class="form-inline">
                        <input type="hidden" name="bookId" value="<c:out value="${book.id}"/>">
                        <input type="number" name="quantity" value="1" min="1">
                        <input type="submit" value="<fmt:message key='books.add_cart'/>">
                    </form>
                </td>
                <c:if test="${sessionScope.user.role eq 'MANAGER' || sessionScope.user.role eq 'ADMIN'}">
                    <td><a href="controller?command=book_edit_form&id=<c:out value="${book.id}"/>">Edit</a></td>
                    <td>
                        <form method="post" action="controller?command=book_delete&id=<c:out value="${book.id}"/>">
                            <input type="submit" value="<fmt:message key='books.button_delete'/>">
                        </form>
                    </td>
                </c:if>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</c:if>

</body>
</html>

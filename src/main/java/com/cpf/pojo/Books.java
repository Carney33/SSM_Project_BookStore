package com.cpf.pojo;

public class Books {
    private Integer bookId;

    private String bookName;

    private String detail;

    private Integer price;

    public Books(Integer bookId, String bookName, String detail, Integer price) {
        this.bookId = bookId;
        this.bookName = bookName;
        this.detail = detail;
        this.price = price;
    }

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName == null ? null : bookName.trim();
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail == null ? null : detail.trim();
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }
}
package lib;

public class Book {

    private int id;
    private String name, author, category;
    private float price;

    public Book(int id, String name, String author, String category, float price) {
        this.id = id;
        this.name = name;
        this.author = author;
        this.category = category;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getAuthor() {
        return author;
    }

    public String getCategory() {
        return category;
    }

    public float getPrice() {
        return price;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return id + ", " + name + ", " + author + ", " + category + ", " + price;
    }

}
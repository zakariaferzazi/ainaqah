class SearchRequest {
    List<int>? price;
    List<Map<String,Object>>? attribute;
    String? text;
    String? bestSelling;
    String? onSale;
    String? featured;
    String? newest;
    String? specialProduct;
    int? page;


    SearchRequest({this.price, this.attribute, this.text,this.bestSelling,
    this.onSale,
    this.featured,
    this.newest,
    this.specialProduct});


    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if(text!=null && text!.isNotEmpty){
            data['text'] = this.text;
        }
        if (this.price != null) {
            data['price'] = this.price;
        }
        if (this.attribute != null && this.attribute!.isNotEmpty) {
            data['attribute'] = this.attribute;
        }
        if(this.bestSelling!=null && this.bestSelling!.isNotEmpty){
            data['Optional_selling']=this.bestSelling;
        }
        if(this.onSale!=null && this.onSale!.isNotEmpty){
            data['on_sale']=this.onSale;
        }
        if(this.featured!=null && this.featured!.isNotEmpty){
            data['featured']=this.featured;
        }
        if(this.newest!=null && this.newest!.isNotEmpty){
            data['newest']=this.newest;
        }
        if(this.specialProduct!=null && this.specialProduct!.isNotEmpty){
            data['special_product']=this.specialProduct;
        }
        data['page']=this.page;
        return data;
    }
}


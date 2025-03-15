// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;
contract MobileShop {
uint public counter=0;//محصول را می شمارد و مقدار پیش فرض ان صفر است
struct product{ //ساختار محصول
    uint id;  //ای دی محصول
    string name; //نام محصول
    uint price; //قیمت محصول
    address payable owner; // مالک محصول
    bool sold; //وضعیت فروش محصول
}
 mapping (uint => product) public products; //در این مپینگ یک متغیر عدد و محصول ا که در استراکت تعریف کردیم را به مپینگ می دهیم تا ان را در یک جدول مانند به همراه شماره اش ذخیره کند

////////////////////////////////////////////////

event createProduct(uint id,string name,uint price,address payable  owner,bool sold); //تعریف یک ایونت برای پر شدن بخض خرید محصول
event sellProduct(uint id,string name,uint price,address payable  owner,bool sold);//تعریف یک ایونت برای پر شدن بخض فروش محصول

function productCreate(string memory _name, uint _price) public  { //یک فانکشن می نویسیم و دو مقداری قیمت و نام محصول را به عنوان ورودی به ان می دهیم
    require(bytes(_name).length>0,"err: name not valid...");//شرط می گذاریم که اگر متغیر نام ما مقدار نداشت ارور بده 
    require(_price>0,"err: price not valid...");//شرط می گذاریم که اگر متغیر قیمت مقدار نداشت ارور بده
    counter++; //اگر متغیر های ما هر دو مقدار داشتن یک عدد اضافه کن به ای دی 
    products[counter]=product(counter,_name,_price,payable(msg.sender),false); //  در این بخش مپینگ خود را پر می کنیم و مقدار دهی می کنیم و شمارنده را هم به مپینگ پاس می دهیم و سپس ان را مقدار دهی می کنیم
    emit createProduct(counter,_name,_price,payable(msg.sender),false); // و در نهایت ایونت ایجاد محصول را پر می کنیم با استفاده از امیت
}
function productSell(uint _id) public payable  { //یک فانکشن می نویسیم ومقدار ای دی را به ان می دهیم که ای دی محصول فروش رفته را پیدا کنیم
product memory productSearch=products[_id];//از ساختار یا همان استراکت با نام پروداکت یک متغیر با نام پروداکت سرچ می سازیم که این متغیر وظیفه دارد تا از داخل محصولات در مپینگ مقدار ای دی را جستجو و پیدا کند 
require(productSearch.id>0 && productSearch.id<=counter , "err: id not valid");// در این شرط هم مشخص می کنیم که محصولی خریداری شده ای دی صفر نداشته باشد و مقدار ای دی از مقدار شمارنده بیشتر نباشد (یعنی 10 محصول داشته باشیم و یک محصول ای دی یازده داشته باشد)
address payable  seller=productSearch.owner;//پیدا کردن صاحب و مالک محصول
require(msg.value >= productSearch.price,"err:eth not value...."); //در این شرط تعریف می کنیم که مقدار پولی که کاربر می دهم بزرگ تر یا هم اندازه قیمت محصول باشد و کم تر نباشد 
require(msg.sender !=seller,"err: you are owner product");//اگر خریدار صاحب و مالک همان محصولی بود که قصد خرید ان را داشت ارور بده که شما مالک محصول هستی
productSearch.owner=payable (msg.sender);//اگز تمام شرط های بالا درست بود ادرس مالک تغییر کند و مالک جدسد فرد خریدار شود
productSearch.sold=true; //ان مقدار بولین که در بالا تعریف کردیم و فالس قراردادیم به معنی این که هنوز محصول فروش نرفته را ترو می کنیم که به معنی فروش رفته می باشد

products[_id]=productSearch; //در مپینگ اطلاعات خریدار جدید و محصول را ذخیره می کنیم و مپینگ را اپدیت می کنیم

seller.transfer(msg.value); //کم شدن موجودی فرد خریدار و واریز به فروشنده

emit sellProduct(_id,productSearch.name,productSearch.price,payable(msg.sender),true);    //ایونت فروش محصول را پر می کنیم
}

}
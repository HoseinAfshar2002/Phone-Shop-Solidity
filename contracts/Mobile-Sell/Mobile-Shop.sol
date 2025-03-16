// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract MobileShop {
    uint public counter = 0;

    struct product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool sold;
    }

    mapping(uint => product) public products;

    event createProduct(uint id, string name, uint price, address payable owner, bool sold);
    event sellProduct(uint id, string name, uint price, address payable owner, bool sold);

    function productCreate(string memory _name, uint _price) public {
        require(bytes(_name).length > 0, "err: name not valid...");
        require(_price > 0, "err: price not valid...");
        counter++;
        products[counter] = product(counter, _name, _price, payable(msg.sender), false);
        emit createProduct(counter, _name, _price, payable(msg.sender), false);
    }

    function productSell(uint _id) public payable {
        product memory productSearch = products[_id];
        require(productSearch.id > 0 && productSearch.id <= counter, "err: id not valid");
        address payable seller = productSearch.owner;
        require(msg.value >= productSearch.price, "err: eth not value....");
        require(msg.sender != seller, "err: you are owner product");
        productSearch.owner = payable(msg.sender);
        productSearch.sold = true;
        products[_id] = productSearch;
        seller.transfer(msg.value);
        emit sellProduct(_id, productSearch.name, productSearch.price, payable(msg.sender), true);
    }
}

<h1 style="font-size: 24px;">E-Buy</h1>

<h2 style="font-size: 14px;">Project Describtion</h1>


•	Aplikacioni E-Buy është një aplikacion mobil i zhvilluar në Swift duke përdorur UIKit si dhe SQLLite për ruajten e të dhënave në databazë. 

•	Ky aplikacion ofron përdoruesve aftësinë për të shfletuar një listë të produkteve në faqen kryesore, i shton ato në shportë, dhe menaxhon artikujt në shportë.

•	Projekti përbëhet nga dy view kontrollera kryesore: HomePageController dhe CartPageController.

<h2 style="font-size: 14px;">Features</h1>

<h3 style="font-size: 14px;">Home Page</h3>

•	Shfaq një listë të produkteve të marrura nga një bazë të dhënash lokale.

•	Çdo produkt paraqitet me titullin, çmimin dhe një imazh i ngarkuar asinkronisht duke përdorur bibliotekën SDWebImage.

•	Përdoruesit mund të shtojnë produkte në shportë duke trokitur në butonin "Shto në Shportë".

<h3 style="font-size: 14px;">Cart Page</h3>

•	Shfaq një përmbledhje të produkteve të shtuara në shportë.

•	Tregon çmimin total të artikujve në shportë.

•	Përdoruesit mund të heqin produkte nga shporta ose të vazhdojnë me blerjen.

•	Siguron përditësime në kohë reale, duke marrë të dhëna nga baza e të dhënave çdo herë që paraqitet faqja.

<h2 style="font-size: 14px;">Components</h1>

<h3 style="font-size: 14px;">Interaksioni me Bazën e të dhënave</h3>

•	Përdor një klasë DataBaseManager për të komunikuar me bazën e të dhënave lokale(inner database).

•	Merr produkte nga baza e të dhënave për faqen kryesore dhe për shportën.

•	Menaxhon operacionet lidhur me shportën, si futjen, heqjen dhe përditësimin e sasive të produkteve.

<h3 style="font-size: 14px;">Interaksioni me përdoruesin</h3>

•	Siguron ndërveprimin e përdoruesit përmes butonave në qeliza për shtimin e produkteve në shportë, blerjen e produkteve dhe largimin e artikujve nga shporta.

•	Shfaq sinjalizime për të informuar përdoruesit për veprime të suksesshme ose gabime.

<h2 style="font-size: 14px;">Usage</h1>

•	Klononi repozitorin.

•	Hapni projektin në Xcode.

•	Ekzekutoni aplikacionin në një simulues ose një pajisje fizike.

•	Shfletoni produkte në faqen kryesore, shtoni ato në shportë, dhe menaxhoni artikujt në shportë në faqen e shportës.

<h2 style="font-size: 14px;">Dependencies</h1>

•	Biblioteka SDWebImage:

•	Përdoret për ngarkimin efikas të imazheve të produkteve asinkronisht.

<h2 style="font-size: 24px;">Screenshots</h2>

Home Page:        

![HomePageLook](https://github.com/GjemaVisar/E-Buy/assets/115551440/1f3f2538-db4b-4102-95fd-241fe655b7ea)

Cart Page with no products added:  

![CartPage0](https://github.com/GjemaVisar/E-Buy/assets/115551440/d3d59eaa-4956-4673-9c56-a2563d447af8)

Products in cart, total value	Buying a product: 

![CartPage1](https://github.com/GjemaVisar/E-Buy/assets/115551440/781df613-cb7f-4491-9f8e-712abdf12524)
                 
Removing a product from Cart

![CartPage2](https://github.com/GjemaVisar/E-Buy/assets/115551440/91423ad2-430f-4c5c-aec4-8a5ca7750d97)

Buying a product from Cart

![CartPage3](https://github.com/GjemaVisar/E-Buy/assets/115551440/02a3a1c4-0316-4a28-a4ce-1b5207bfe145)

 Adding a product to Cart
 
![AddingProductToCart](https://github.com/GjemaVisar/E-Buy/assets/115551440/72bc4eb6-3e7f-4a56-aadb-beeae3661914)















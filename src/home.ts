import express from 'express';

const app = express.Router();

const dataForHome = {
    "category" : [
        {
            "name": "Home Cleaning",
            "subcategory": [
                "Daily Cleaning",
                "Pembersihan Dapur dan Kulkas",
            ],
        },
        {
            "name": "Deep Cleaning",
            "subcategory": [
                "Cuci Kasur",
                "Bersih Kamar Mandi",
            ],
        },
        {
            "name": "Plumbing Services",
            "subcategory": [
                "Perbaikan pipa bocor",
                "Pembersihan Saluran Air",
            ],
        },
        {
            "name": "Electrical Repairs",
            "subcategory": [
                "Instalasi Lampu",
                "Perbaikan Saklar dan Stop Kontak",
            ],
        },
        {
            "name": "Pest Control",
            "subcategory": [
                "Pengendalian Tikus",
                "Pembasmian Kutu",
            ],
        },
    ],
};

app.get('/', (req, res) => {
    res.render('home/home.hbs', { data: JSON.stringify(dataForHome), han : dataForHome });
});

export default app;
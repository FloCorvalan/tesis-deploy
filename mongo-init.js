use prueba;
db.createUser({
    user: "admin",
    pwd: "adm1n!",
    roles: [{
        role:"readWrite",
        db: "prueba"
    }]
});
exit;
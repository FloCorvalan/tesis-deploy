db.createUser({
    user: "admin",
    pwd: "",
    roles: [{
        role:"readWrite",
        db: "prueba"
    }]
})
import Vapor
import Fluent

class User {
    var id: Value?
    var username: String
    var password: String
    var token: String
    
    var name: String? = nil
    var profile_pic_url: String? = nil
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.token = (username+password).sha256String
    }
    
    required init(serialized: [String: Value]) {
    	id = serialized["id"]
    	
        name = serialized["name"]?.string
    	profile_pic_url = serialized["profile_pic_url"]?.string
        
    	username = serialized["username"]?.string ?? ""
    	password = serialized["password"]?.string ?? ""
    	token = serialized["token"]?.string ?? ""
    }
}

extension User: Schemable {
    static let schema = "CREATE TABLE IF NOT EXISTS users (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "username TEXT NOT NULL, password TEXT NOT NULL," +
        "token TEXT NOT NULL, name TEXT," +
        "profile_pic_url TEXT);"
}

extension User: Model {
    
    func serialize() -> [String: Value?] {
        var out = [String: Value?]()
    
        out["name"] = self.name
        out["profile_pic_url"] = self.profile_pic_url
        
        out["username"] = self.username
        out["password"] = self.password
        out["token"] = self.token
        
        return out
    }
    
    class var table: String {
    	return "users"
    }

}


extension User: JSONRepresentable {
    func makeJson() -> JSON {
        return JSON([
            "username": self.username,
            "password": self.password,
            "token": self.token,
            "profile_pic_url": self.profile_pic_url ?? ""
        ])
    }
}

import QuickEnum

struct Container {

    @Enum("edit", "new") var viewMode: ViewMode = .edit
    
    #enum("NamedEnum", cases: "edit", "new", "view")
    
}

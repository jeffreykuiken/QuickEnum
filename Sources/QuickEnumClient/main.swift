import QuickEnum

struct Container {

    @Enum("edit", "new") var viewMode: ViewMode = .edit
    
    #Enum("NamedEnum", cases: "edit", "new", "view")
    
}

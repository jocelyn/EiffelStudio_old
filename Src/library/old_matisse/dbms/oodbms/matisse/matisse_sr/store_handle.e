class STORE_HANDLE
 
feature -- Access

	storer :  CELL[STORER] is once !!Result.put(Void) end

	retriever : CELL[RETRIEVER] is once !!Result.put(Void) end

feature {NONE} -- Access

	basic_storer : BASIC_STORER32 is once !!Result.make(1024) end    

	matisse_storer : MATISSE_STORER is once !!Result end

	basic_retriever : BASIC_RETRIEVER is once !!Result end

	matisse_retriever : MATISSE_RETRIEVER is once !!Result end

feature -- Status Setting

	-- Files
	set_basic_store is do storer.put(basic_storer) end

	-- Databases
	set_matisse_storer is do storer.put(matisse_storer) end -- set_matisse_storer
	set_matisse_retriever is do retriever.put(matisse_retriever) end -- set_matisse_retriever

end -- class STORE_HANDLE

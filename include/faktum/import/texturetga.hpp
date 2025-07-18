#pragma once

// Includes


// Forward declarations

class /* Attributes */ FImportTextureTGA : /* Bases */ {

public:

	FImportTextureTGA(FImportTextureTGA const&);
	FImportTextureTGA();

	virtual ~FImportTextureTGA();

	FImportTextureTGA& operator=(FImportTextureTGA const&);

	static void* __cdecl operator new(unsigned int, FObject*, FName const&, FName const&, unsigned int);

	virtual wchar_t const* GetExtension(unsigned int);
	virtual unsigned int GetExtensionCount();
	virtual FClass* GetImportClass();
	virtual FObject* ImportObject(wchar_t const*, FObject*, FName const&, FName const&, FObject*, FObject*);

	static void __cdecl StaticConstructor(void*);
	static FClass* __cdecl StaticGetClass();
	static void __cdecl StaticUnregisterClass();

private:

	static FClass* __cdecl StaticConstructClassFImportTextureTGA();
	static void __cdecl StaticInitClassFImportTextureTGA();

	void FlipImage(Header*, FBitmap*);
	int Read(FArchive*, Header*, FTexture*);
	int ReadBW(FArchive*, Header*, FTexture*);
	int ReadColMap(FArchive*, Header*, FTexture*);
	int ReadCompressedData(FArchive*, Header*, FBitmap*, ColMap*);
	int ReadUncompressedData(FArchive*, Header*, FBitmap*, ColMap*);

	static FClass* ms_pClass;

};
_SIZE_GUARD(FImportTextureTGA, /* Size */);

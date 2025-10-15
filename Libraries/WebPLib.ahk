#NoEnv
#SingleInstance Force

HBitmapFromWebP(webpImagePath) {
   static CLSID_WICImagingFactory       := "{CACAF262-9370-4615-A13B-9F5539DA4C0A}"
         , IID_IWICImagingFactory       := "{EC5EC8A9-C395-4314-9C77-54D7A935FF70}"
         , GUID_WICPixelFormat32bppBGRA := "{6FDDC324-4E03-4BFE-B185-3D77768DC90F}"
         , GENERIC_READ := 0x80000000, decodeOption := WICDecodeMetadataCacheOnDemand := 0
         , dither := WICBitmapDitherTypeNone := 0, paletteType := WICBitmapPaletteTypeCustom := 0
         
   IWICImagingFactory := ComObjCreate(CLSID_WICImagingFactory, IID_IWICImagingFactory)
   VTable( IWICImagingFactory, CreateDecoderFromFilename :=  3 ).Call( "Str", webpImagePath, "Ptr", 0, "UInt", GENERIC_READ
                                                                     , "Int", decodeOption, "PtrP", IWICBitmapDecoder )
   VTable( IWICImagingFactory, CreateFormatConverter     := 10 ).Call("PtrP", IWICFormatConverter)
   
   VTable( IWICBitmapDecoder, GetFrame := 13 ).Call("UInt", 0, "PtrP", IWICBitmapFrameDecode)
   
   VarSetCapacity(CLSID, 16)
   DllCall("Ole32\CLSIDFromString", "Str", GUID_WICPixelFormat32bppBGRA, "Ptr", &CLSID)
   VTable( IWICFormatConverter, Initialize := 8 ).Call( "Ptr", IWICBitmapFrameDecode, "Ptr", &CLSID
                                                      , "Int", dither, "Ptr", 0, "Double", 0, "Int", paletteType )
   VTable( IWICFormatConverter, GetSize    := 3 ).Call("UIntP", width, "UIntP", height)
   
   stride := width * 4
   hBitmap := CreateDIBSection(width, height, pBits)
   VTable( IWICFormatConverter, CopyPixels := 7 ).Call("Ptr", 0, "UInt", stride, "UInt", stride * height, "Ptr", pBits)
   
   ObjRelease(IWICFormatConverter), ObjRelease(IWICBitmapFrameDecode)
   ObjRelease(IWICBitmapDecoder), ObjRelease(IWICImagingFactory)
   Return hBitmap
}

Vtable(ptr, n) {
   return Func("DllCall").Bind(NumGet(NumGet(ptr+0), A_PtrSize*n), "Ptr", ptr)
}

CreateDIBSection(w, h, ByRef ppvBits := 0, bpp := 32) {
   hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
   VarSetCapacity(BITMAPINFO, 40, 0)
   NumPut(40 , BITMAPINFO,  0, "UInt")
   NumPut( w , BITMAPINFO,  4, "UInt")
   NumPut(-h , BITMAPINFO,  8, "UInt")
   NumPut( 1 , BITMAPINFO, 12, "UShort")
   NumPut(bpp, BITMAPINFO, 14, "UShort")
   hBM := DllCall("CreateDIBSection", "Ptr", hDC, "Ptr", &BITMAPINFO, "UInt", 0
                                    , "PtrP", ppvBits, "Ptr", 0, "UInt", 0, "Ptr")
   DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
   return hBM
}
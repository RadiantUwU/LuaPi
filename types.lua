export type LuaPiObject = {
    __class__: LuaPiType
}

export type LuaPiO_A = LuaPiObject | any?
export type LuaPiO_N = LuaPiO_A | number
export type LuaPiO_S = LuaPiO_A | string
export type LuaPiO_B = LuaPiO_A | boolean
export type LuaPiO = LuaPiObject
export type Weakref<T> = {
    get: (Weakref<T>) -> T,
    set: (Weakref<T>, T) -> nil
}

export type LuaPiType = LuaPiObject & {
    __mro__:     {LuaPiType}                              ,
    __bases__:   {LuaPiType}                              ,
    __fields__:  {[string]:AccessInfo}                    ,
    __name__:    LuaPiO_S                                 ,
    
    __add__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __sub__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __mul__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __div__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __idiv__:    (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __mod__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __pow__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __unm__:     (LuaPiO     		      ) -> LuaPiO_N   ,
    __band__:    (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __bor__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __bxor__:    (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __bnot__:    (LuaPiO     		      ) -> LuaPiO_N   ,
    __shl__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    __shr__:     (LuaPiO,LuaPiO_N		  ) -> LuaPiO_N   ,
    
    __concat__:  (LuaPiO,LuaPiO_S		  ) -> LuaPiO_S   ,
    
    __bool__:    (LuaPiO     		      ) -> LuaPiO_B   ,
    __num__:     (LuaPiO     		      ) -> LuaPiO_N   ,
    __str__:     (LuaPiO       		      ) -> LuaPiO_S   ,
    __len__:     (LuaPiO                  ) -> LuaPiO_N   ,
    
    __getitem__: (LuaPiO,LuaPiO_S         ) -> LuaPiO_A   ,
    __setitem__: (LuaPiO,LuaPiO_S,LuaPiO_A) -> nil        ,
    
    __lt__:      (LuaPiO,LuaPiO           ) -> boolean    ,
    __eq__:      (LuaPiO,LuaPiO           ) -> boolean    ,
    __gt__:      (LuaPiO,LuaPiO           ) -> boolean    ,
    
    __call__:    (LuaPiO,...LuaPiO_A      ) -> LuaPiO_A   ,
    
    __new__:     (LuaPiType,...LuaPiO_A   ) -> LuaPiO,
    __init__:    (LuaPiO,...LuaPiO_A      ) -> LuaPiO_A   , --default nil
    __del__:     (LuaPiO                  ) -> nil        ,
    
    __iter__:    (LuaPiO                  ) -> ...LuaPiO_A, --return the iter object, optionally a starting index
    __next__:    (LuaPiO,LuaPiO_A         ) -> LuaPiO_A
}

export type LuaPiObjectInfo = {
    contents:         {[any]: any}                      ,
    protectedcontent: {[any]: any}                      ,
    privatecontent:   {[LuaPiType]:{[any]: any}}        ,
    type:             LuaPiType                         ,
    frozen:           boolean                           ,
    unlockprivate:    boolean                           ,
    authorized:       {[(...any) -> ...any]: LuaPiType?},
    notauthorized:    {[(...any) -> ...any]: LuaPiType?},
    authf:            () -> ()?
}
export type AccessInfo = {
    securityaccessor: "public" | "protected" | "private",
    static:           boolean                           ,
    classowns:        boolean                           ,
}
export type LuaPiTypeInfo = LuaPiObjectInfo & {
    mro:             {LuaPiType}          ,
    bases:           {LuaPiType}          ,
    fields:          {[string]:AccessInfo},
    protectedfields: {[string]:any?}      ,
    privatefields:   {[string]:any?}      ,
    final:           boolean
}
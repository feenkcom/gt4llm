Trait {
	#name : #TGtLWithInputModelsAPI,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addInputMagritteObject: anObject named: aString [
	self addInputModel: (GtLMagritteBasedModel new
		name: aString;
		model: anObject)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addInputModel: aModel [
	self inputModels add: aModel.
]

{ #category : #'api - models' }
TGtLWithInputModelsAPI >> addPlainInputObject: anObject named: aString [
	self 
		addWrappedObject: (GtLObjectValueResult 
			forObject: anObject)
		named: aString
]

{ #category : #'api - models' }
TGtLWithInputModelsAPI >> addPlainInputObject:  anObject withId: aStoredObjectId named: aString [
	self 
		addWrappedObject: (GtLObjectStorageValueResult 
			forObject: anObject
			withId: aStoredObjectId)
		named: aString
]

{ #category : #'api - models' }
TGtLWithInputModelsAPI >> addWrappedObject: anObject [
	self addInputModel: (GtLWrappedObjectModel new
		model: anObject)
]

{ #category : #'api - models' }
TGtLWithInputModelsAPI >> addWrappedObject: anObject named: aString [
	self addInputModel: (GtLWrappedObjectModel new
		model: anObject;
		name: aString)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addWrappedObjects: aCollectionOfObjects [

	aCollectionOfObjects do: [ :object |
		self addWrappedObject: object ].
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> gtPage: aPageName [
	self pageObject: (LeDatabase gtBook  
		pageNamed: aPageName)
]

{ #category : #views }
TGtLWithInputModelsAPI >> gtViewInputModelsFor: aView [
	<gtView>
	<gtLlmView>
	self inputModels ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Input models';
		priority: 10;
		items: [ self inputModels ];
		column: 'Name' text: [ :each | each name ifNil: [ '-' ] ] width: 200;
		column: 'Object' text: [ :each | each value description ]
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> images: aCollection [
	self addWrappedObjects: (aCollection collect: [ :each | 
		GtLImageFile fileReference: each ])
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> markdown: aString [
	self
		addInputMagritteObject: (GtLMarkdown new content: aString)
		named: 'Markdown'
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> markdownPage: aPageName [
	self 
		markdownPageObject: (LeDatabasesRegistry defaultLogicalDatabase 
			pageNamed: aPageName)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> markdownPageObject: aLepiterPage [
	self 
		addInputMagritteObject: (GtLMarkdown new
				content: ((GtLLepiterContentExporter new)
						startHeaderLevel: 2;
						page: aLepiterPage;
						export))
		named: aLepiterPage title
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> page: aPageName [
	self pageObject: (LeDatabasesRegistry defaultLogicalDatabase  
		pageNamed: aPageName)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> pageId: aPageId [
	self pageObject: (LeDatabasesRegistry defaultLogicalDatabase  
		pageWithID: aPageId)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> pageObject: aLepiterPage [
	self 
		addWrappedObject: (GtLLepiterPage forPage: aLepiterPage)
		named: aLepiterPage title
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> pdfs: aCollection [
	self addWrappedObjects: (aCollection collect: [ :each | 
		GtLPdfFile fileReference: each ])
]

{ #category : #printing }
TGtLWithInputModelsAPI >> string: aString [
	self
		addWrappedObject: (GtLString forString: aString)
]

{ #category : #printing }
TGtLWithInputModelsAPI >> string: aString named: aName [
	self
		addWrappedObject: (GtLString forString: aString)
		named: aName
]

Trait {
	#name : #TGtLWithInputModelsAPI,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addAttachments: aCollectionOfAttachments [
	self attachments addAll: aCollectionOfAttachments
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addInputMagritteObject: anObject named: aString [
	self addInputModel: (GtLMagritteInputModel new
		name: aString;
		model: anObject)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addInputModel: aModel [
	self inputModels at: aModel name put: aModel.
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addPlainInputObject: anObject named: aString [
	self addInputModel: (GtLPlainObjectInputModel new
		name: aString;
		model: anObject)
]

{ #category : #accessing }
TGtLWithInputModelsAPI >> attachments [
	self explicitRequirement
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
		items: [ self inputModels associations ];
		column: 'Name' text: [ :each | each key ] width: 200;
		column: 'Object' text: [ :each | each value description ];
		send: [ :each | each value ]
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> images: aCollection [
	self addAttachments: (aCollection collect: [ :each | 
		GtLInputImageFile fileReference: each ])
]

{ #category : #accessing }
TGtLWithInputModelsAPI >> inputModels [
	self explicitRequirement
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
	self addInputModel: (GtLLepiterPageInputModel new
			name: aLepiterPage title;
			model: aLepiterPage)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> pdfs: aCollection [
	self addAttachments: (aCollection collect: [ :each | 
		GtLInputPdfFile fileReference: each ])
]

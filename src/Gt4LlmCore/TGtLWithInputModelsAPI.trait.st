Trait {
	#name : #TGtLWithInputModelsAPI,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addInputMagritteObject: anObject named: aString [
	self addInputModel: (GtLMagritteInputModel new
		name: aString;
		model: anObject)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addInputModel: anInputModel [
	^ self explicitRequirement
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> addPlainInputObject: anObject named: aString [
	self addInputModel: (GtLPlainObjectInputModel new
		name: aString;
		model: anObject)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> gtPage: aPageName [
	self pageObject: (LeDatabase gtBook  
		pageNamed: aPageName)
]

{ #category : #'api - message' }
TGtLWithInputModelsAPI >> markdown: aString [
	self
		addInputMagritteObject: (GtLMarkdown new content: aString)
		named: 'Markdown'
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

Trait {
	#name : #TGtLWithInstructionSectionAPI,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #adding }
TGtLWithInstructionSectionAPI >> addToExplanationSectionLepiterPage: aLepiterPage [
	| instructionString explanationSection |
	explanationSection := self instructions ensureSectionNamed: 'Explanations'.

	instructionString := GtLLepiterContentExporter new
			startHeaderLevel: explanationSection headerLevel + 1;
			page: aLepiterPage;
			export.

	explanationSection body
		addItem: (GtLInstructionSection new
				title: aLepiterPage title;
				body: instructionString)
]

{ #category : #adding }
TGtLWithInstructionSectionAPI >> addToExplanationSectionNamed: aTitle withContent: aContentString [

	(self instructions ensureSectionNamed: 'Explanations')
		addSection: (GtLlmInstructionSection new
				title: aTitle;
				body: aContentString).
]

{ #category : #'api - instructions' }
TGtLWithInstructionSectionAPI >> gtPageExplanation: aPageName [
	self pageObjectExplanation: (LeDatabase gtBook  
		pageNamed: aPageName)
]

{ #category : #'api - instructions' }
TGtLWithInstructionSectionAPI >> pageExplanation: aPageName [
	self pageObjectExplanation: (LeDatabasesRegistry defaultLogicalDatabase  
		pageNamed: aPageName)
]

{ #category : #'api - instructions' }
TGtLWithInstructionSectionAPI >> pageIdExplanation: aPageId [
	self pageIdExplanation: aPageId from: LeDatabasesRegistry defaultLogicalDatabase 
]

{ #category : #'api - instructions' }
TGtLWithInstructionSectionAPI >> pageIdExplanation: aPageId from: aDatabase [
	self pageObjectExplanation: (aDatabase pageWithID: aPageId)
]

{ #category : #'api - instructions' }
TGtLWithInstructionSectionAPI >> pageObjectExplanation: aLepiterPage [
	self addToExplanationSectionLepiterPage: aLepiterPage
]

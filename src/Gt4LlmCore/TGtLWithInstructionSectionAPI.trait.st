Trait {
	#name : #TGtLWithInstructionSectionAPI,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #adding }
TGtLWithInstructionSectionAPI >> addToExplanationSectionLepiterPage: aLepiterPage [
	| instructionString |
	
	instructionString := GtLLepiterContentExporter new
			startHeaderLevel: 2;
			page: aLepiterPage;
				export.
	
	(self instructions ensureSectionNamed: 'Explanations')
		addSection: (GtLlmInstructionSection new
				title: aLepiterPage title;
				body: instructionString).
]

{ #category : #instructions }
TGtLWithInstructionSectionAPI >> buildCompleteInstructions [
	| newInstructions  |
	newInstructions := GtLlmInstructionWithSections new
			introduction: (GtLlmInstructionString new string: '').
	
	self inputModels notEmpty
		ifTrue: [ 
			| inputInstructionsBody inputInstructions |
			inputInstructionsBody := GtLlmInstructionWithSections new
					introduction: 'The inputs provided follow the descriptions below'.
			inputInstructions := GtLlmInstructionSection new
					title: 'Input descriptions';
					body: inputInstructionsBody.
			newInstructions addSection: inputInstructions.
			self inputModels
				do: [ :anInputModel | anInputModel addInstructionsTo: inputInstructionsBody ] ].
				
	^ newInstructions
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

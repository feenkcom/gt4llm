Class {
	#name : #GtLTools,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #defaults }
GtLTools class >> files [
	^ self
		withAll: {
			GtLMagritteToolForDirectoryContents new . 
			GtLMagritteToolForFilesContents new. 
			"GtLMagritteToolForFilesGrep new ." 
			GtLMagritteToolForFilesWrite new.
			GtLMagritteToolForFileInformation new.
			GtLMagritteToolForFilesInformation new } asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gt [
	^ self gtSearch , self leSearch , self gtCodeChange , self leChange
		, self gtExamplesRun
		, {GtLMagritteToolForSmalltalkCodeEvaluation new.
				GtLToolForObjectView new.
				GtLToolForObjectStorageList new}
]

{ #category : #defaults }
GtLTools class >> gtCodeChange [
	^ self
		withAll: {GtLMagritteToolForClassesCreation new.
					GtLMagritteToolForClassDefinitionChange new.
					GtLMagritteToolForClassCommentChange new.
					GtLMagritteToolForMethodsCompilation new.
					GtLMagritteToolForMethodsRemoval new.
					GtLMagritteToolForClassRemoval new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gtCodeRemoval [
	^ self
		withAll: {GtLMagritteToolForClassRemovalExamples new.
					GtLMagritteToolForMethodRemoval new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gtExamplesRun [
	^ self
		withAll: {GtLToolForExampleMethodRun new.
				GtLToolForExampleClassesRun new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> gtSearch [
	^ self
		withAll: {
				GtLMagritteToolForClassSearch new.
				GtLMagritteToolForClassSubclasses new.
				GtLMagritteToolForClassLookup new.
				GtLMagritteToolForClassReferences new.
				GtLMagritteToolForMethodReferences new.
				GtLMagritteToolForMethodImplementors new.
				"GtLMagritteToolForMethodSource new."
				GtLMagritteToolForMethodsSource new.
				GtLMagritteToolForPackageClasses new.
				GtLMagritteToolForSubstringLiteralSearch new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> leChange [
	^ self
		withAll: {GtLToolForLepiterPageCreate new.
				GtLToolForLepiterPageRemove new.
				GtLToolForLepiterSnippetEdit new.
				GtLToolForLepiterSnippetsCreate new.
				GtLToolForLepiterSnippetsRemove new} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> leSearch [
	^ self
		withAll: {GtLToolForLepiterKnowledgeBases new.
				GtLToolForSearchForLepiterPages new.
				GtLToolForLepiterPageContents new.} asOrderedCollection
]

{ #category : #defaults }
GtLTools class >> lepiter [
	^ self leSearch
		, self leChange
]

{ #category : #defaults }
GtLTools class >> sunitRun [
	self 
		deprecated: 'Please use #testRun instead.'
		transformWith: '`@receiver sunitRun' -> '`@receiver testRun'.
	^ self testRun
]

{ #category : #defaults }
GtLTools class >> testRun [
	^ self
		withAll: {GtLToolForTestMethodRun new.
				GtLToolForTestClassesRun new} asOrderedCollection
]

{ #category : #'as yet unclassified' }
GtLTools >> , aCollection [
	self addAll: aCollection
]

{ #category : #views }
GtLTools >> gtItemsFor: aView [
	<gtView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Tools';
		items: [ items ];
		column: 'Name' text: [ :each | each name ];
		column: 'Parameters' text: [ :each | each parametersDescription ];
		column: 'Description' text: [ :each | each description ]
]

{ #category : #'as yet unclassified' }
GtLTools >> items: aCollection [
	self removeAll.
	self addAll: aCollection
]

{ #category : #actions }
GtLTools >> performToolCall: aToolCall [
	^ self 
			performToolCall: aToolCall 
			inContext: (GtLToolExecutionContext new )
]

{ #category : #actions }
GtLTools >> performToolCall: aToolCall inContext: anExecutionContext [
	| tool |
	tool := self detect: [ :aTool | aTool name = aToolCall name ].

	^ tool performToolCall: aToolCall inContext: anExecutionContext
]

{ #category : #accessing }
GtLTools >> serialize [
	^ Character cr join: (self items collect: [ :aTool | '- ' , aTool serialize ])
]

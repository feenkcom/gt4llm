Class {
	#name : #GtLlmContext,
	#superclass : #Object,
	#instVars : [
		'checker',
		'instance',
		'hasInstance',
		'isImmutableInstance',
		'chat'
	],
	#category : #'Gt4Llm-Context'
}

{ #category : #accessing }
GtLlmContext class >> defaultCodeblockPipeline [
	^ self new
		checker: (GtLlmAlternativeCodeStep new
				addAlternative: (GtLlmCompositeCodeStep new
							addStep: GtLlmSmalltalkParserCodeStep new;
							addStep: GtLlmSmalltalkExecutorCodeStep new)
					matching: [ :aContext | aContext lastResult isForLanguage: 'smalltalk' ];
				addAlternative: (GtLlmCompositeCodeStep new
							addStep: GtLlmPythonParserCodeStep new;
							addStep: GtLlmPythonExecutorCodeStep new)
					matching: [ :aContext | aContext lastResult isForLanguage: 'python' ];
				addAlternative: (GtLlmCompositeCodeStep new
							addStep: GtLlmSmalltalkMethodParserCodeStep new;
							addStep: (GtLlmAlternativeCodeStep new
									addAlternative: GtLlmSmalltalkViewExecutorCodeStep new
										matching: [ :aContext | aContext lastResult methodAst hasPragmaNamed: #gtView ];
									addAlternative: GtLlmSmalltalkMethodExecutorCodeStep new
										matching: [ :_ | true ]))
					matching: [ :aContext | aContext lastResult isForLanguage: 'smalltalk-method' ])
]

{ #category : #accessing }
GtLlmContext class >> defaultJsonPipeline [
	^ self new
		checker: (GtLlmAlternativeCodeStep new
				addAlternative: (GtLlmCompositeCodeStep new
							addStep: GtLlmValueExtractorCodeStep new;
							addStep: GtLlmSmalltalkParserCodeStep new;
							addStep: GtLlmSmalltalkExecutorCodeStep new)
					matching: [ :aContext | aContext lastResult key = 'Smalltalk' ];
				addAlternative: (GtLlmCompositeCodeStep new
							addStep: GtLlmValueExtractorCodeStep new;
							addStep: GtLlmPythonParserCodeStep new;
							addStep: GtLlmPythonExecutorCodeStep new)
					matching: [ :aContext | aContext lastResult key = 'Python' ];
				addAlternative: (GtLlmCompositeCodeStep new
							addStep: GtLlmValueExtractorCodeStep new;
							addStep: GtLlmSmalltalkMethodParserCodeStep new;
							addStep: (GtLlmAlternativeCodeStep new
									addAlternative: GtLlmSmalltalkViewExecutorCodeStep new
										matching: [ :aContext | aContext lastResult methodAst hasPragmaNamed: #gtView ];
									addAlternative: GtLlmSmalltalkMethodExecutorCodeStep new
										matching: [ :_ | true ]))
					matching: [ :aContext | aContext lastResult key = 'Smalltalk method' ])
]

{ #category : #accessing }
GtLlmContext >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmContext >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmContext >> check: aString [
	| result |
	result := self checker
			instance: self instance;
			chat: self chat;
			runOn: aString.

	(self hasInstance not
		or: [ self isImmutableInstance not and: [ result isError not ] ])
		ifTrue: [ self instance: result lastResult ].

	^ result
]

{ #category : #accessing }
GtLlmContext >> checker [
	^ checker
]

{ #category : #accessing }
GtLlmContext >> checker: anObject [
	checker := anObject
]

{ #category : #accessing }
GtLlmContext >> gtCheckFor: aView [
	<gtView>
	self checker ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Check';
		priority: 2;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		text: [ '' ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Check'
			action: [ :aButton :aTab | 
				aButton phlow
					spawnObject: (self
							check: (LeParser parse: aTab viewContentElement children first text asString) parts
									first) ]
]

{ #category : #accessing }
GtLlmContext >> gtCompositionFor: aView [
	<gtView>
	self checker ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Composition';
		priority: 1;
		object: [ self checker ];
		view: #gtCompositionFor:
]

{ #category : #accessing }
GtLlmContext >> gtInstanceFor: aView [
	<gtView>
	^ aView forward
		title: 'Instance';
		priority: 3;
		object: [ self instance ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmContext >> hasInstance [
	^ hasInstance
]

{ #category : #accessing }
GtLlmContext >> immutableInstance [
	isImmutableInstance := true
]

{ #category : #accessing }
GtLlmContext >> initialize [
	super initialize.
	
	hasInstance := false.
	isImmutableInstance := false.
]

{ #category : #accessing }
GtLlmContext >> instance [
	^ instance
]

{ #category : #accessing }
GtLlmContext >> instance: anObject [
	instance := anObject.
	hasInstance := true
]

{ #category : #accessing }
GtLlmContext >> isImmutableInstance [
	^ isImmutableInstance ifNil: [ false ]
]

{ #category : #accessing }
GtLlmContext >> isImmutableInstance: anObject [
	isImmutableInstance := anObject
]

{ #category : #accessing }
GtLlmContext >> mutableInstance [
	isImmutableInstance := false
]

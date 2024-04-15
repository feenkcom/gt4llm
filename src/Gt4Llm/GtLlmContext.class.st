Class {
	#name : #GtLlmContext,
	#superclass : #Object,
	#instVars : [
		'checker',
		'instance',
		'hasInstance',
		'isImmutableInstance'
	],
	#category : #'Gt4Llm-Context'
}

{ #category : #accessing }
GtLlmContext class >> defaultPipeline [
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
GtLlmContext >> check: aString [
	| result |
	result := self checker
			instance: self instance;
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
	^ aView textEditor
		title: 'Check';
		priority: 2;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		text: [ '' ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Check'
			action: [ :aButton :aTab | 
				aButton phlow
					spawnObject: (self check: aTab viewContentElement children first text asString) ]
]

{ #category : #accessing }
GtLlmContext >> gtInstanceFor: aView [
	<gtView>
	self hasInstance ifFalse: [ ^ aView empty ].

	^ aView forward
		title: 'Instance';
		priority: 1;
		object: [ self instance ];
		view: #gtLiveFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect result'
			action: [ :aButton | aButton phlow spawnObject: self instance ]
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

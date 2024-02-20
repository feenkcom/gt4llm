Class {
	#name : #GtLlmContext,
	#superclass : #Object,
	#instVars : [
		'checker',
		'instance',
		'hasInstance'
	],
	#category : #'Gt4Llm-Context'
}

{ #category : #accessing }
GtLlmContext class >> defaultPipeline [
	^ self new checker: GtLlmCheckPipeline defaultPipeline
]

{ #category : #accessing }
GtLlmContext >> check: aString [
	| result |
	result := self checker check: aString.

	result hasErrors ifFalse: [ self instance: result lastResult content ].

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
GtLlmContext >> initialize [
	super initialize.
	
	hasInstance := false
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

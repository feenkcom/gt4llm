Class {
	#name : #GtLlmCheckerResult,
	#superclass : #Object,
	#instVars : [
		'content',
		'checker'
	],
	#category : #'Gt4Llm-Checker'
}

{ #category : #accessing }
GtLlmCheckerResult class >> prefix [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmCheckerResult >> asElement [
	^ BlElement new
		size: 12 @ 12;
		geometry: BlCircleGeometry new;
		background: self color
]

{ #category : #accessing }
GtLlmCheckerResult >> asString [
	^ self class prefix, '```text
', self contentString , '
```'
]

{ #category : #accessing }
GtLlmCheckerResult >> checker [
	^ checker
]

{ #category : #accessing }
GtLlmCheckerResult >> checker: anObject [
	checker := anObject
]

{ #category : #accessing }
GtLlmCheckerResult >> color [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmCheckerResult >> content [
	^ content
]

{ #category : #accessing }
GtLlmCheckerResult >> content: aString [
	content := aString
]

{ #category : #accessing }
GtLlmCheckerResult >> contentString [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmCheckerResult >> gtContentFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons playinspect;
		tooltip: 'Inspect result';
		action: [ :aButton | aButton phlow spawnObject: self content ]
]

{ #category : #accessing }
GtLlmCheckerResult >> gtResultFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Result';
		priority: 1;
		text: [ self asString ]
]

{ #category : #accessing }
GtLlmCheckerResult >> isError [
	^ false
]

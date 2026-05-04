"
Models a diff between two strings and can describe itself through Magritte.
"
Class {
	#name : #GtLStringDiff,
	#superclass : #Object,
	#instVars : [
		'fromString',
		'toString'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'instance creation' }
GtLStringDiff class >> from: aSourceString to: aTargetString [
	^ self new
		fromString: aSourceString;
		toString: aTargetString;
		yourself
]

{ #category : #computing }
GtLStringDiff >> differences [
	^ GtDiffBuilder
		computeDifferencesFrom: self fromString
		to: self toString
		using: GtCharacterGroupDiffSplitter words ignoreWhitespace
]

{ #category : #accessing }
GtLStringDiff >> fromString [
	^ fromString
]

{ #category : #accessing }
GtLStringDiff >> fromString: aString [
	fromString := aString
]

{ #category : #magritte }
GtLStringDiff >> fromStringDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'From';
		accessor: #fromString;
		beRequired
]

{ #category : #'gt-views' }
GtLStringDiff >> gtDiffFor: aView [
	<gtView>
	<gtLlmView>
	^ (aView forward)
		title: 'Diff';
		priority: 2;
		object: [ self differences ];
		view: #gtTextView:
]

{ #category : #printing }
GtLStringDiff >> printOn: aStream [
	aStream
		nextPutAll: 'String diff('; 
		print: fromString;
		nextPutAll: ' -> ';
		print: toString;
		nextPut: $)
]

{ #category : #accessing }
GtLStringDiff >> toString [
	^ toString
]

{ #category : #accessing }
GtLStringDiff >> toString: aString [
	toString := aString
]

{ #category : #magritte }
GtLStringDiff >> toStringDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'To';
		accessor: #toString;
		beRequired
]

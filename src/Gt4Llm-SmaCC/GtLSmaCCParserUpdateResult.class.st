Class {
	#name : #GtLSmaCCParserUpdateResult,
	#superclass : #Object,
	#instVars : [
		'parserClass',
		'oldGrammar',
		'newGrammar'
	],
	#category : #'Gt4Llm-SmaCC'
}

{ #category : #'as yet unclassified' }
GtLSmaCCParserUpdateResult >> gtDiffFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Diff';
		priority: 1;
		object: [ GtDiffBuilder
				computeDifferencesFrom: oldGrammar source
				to: newGrammar source
				using: GtCharacterGroupDiffSplitter words ];
		view: #gtTextView:
]

{ #category : #views }
GtLSmaCCParserUpdateResult >> gtNewGrammarFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'New grammar';
		priority: 2;
		object: [ newGrammar ];
		view: #gtLiveFor:
]

{ #category : #views }
GtLSmaCCParserUpdateResult >> gtOldGrammarFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Old grammar';
		priority: 3;
		object: [ oldGrammar ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLSmaCCParserUpdateResult >> newGrammar [
	^ newGrammar
]

{ #category : #accessing }
GtLSmaCCParserUpdateResult >> newGrammar: aGrammar [
	newGrammar := aGrammar
]

{ #category : #accessing }
GtLSmaCCParserUpdateResult >> oldGrammar [
	^ oldGrammar
]

{ #category : #accessing }
GtLSmaCCParserUpdateResult >> oldGrammar: aGrammar [
	oldGrammar := aGrammar
]

{ #category : #accessing }
GtLSmaCCParserUpdateResult >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCParserUpdateResult >> parserClass: aClassName [
	parserClass := aClassName
]

{ #category : #magritte }
GtLSmaCCParserUpdateResult >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Parser Class';
		accessor: #parserClass;
		beRequired
]

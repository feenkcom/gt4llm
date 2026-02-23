Class {
	#name : #GtLSmaCCParserCreationResult,
	#superclass : #Object,
	#instVars : [
		'parserClass',
		'createGrammar'
	],
	#category : #'Gt4Llm-SmaCC'
}

{ #category : #accessing }
GtLSmaCCParserCreationResult >> createGrammar [
	^ createGrammar
]

{ #category : #accessing }
GtLSmaCCParserCreationResult >> createGrammar: aGrammar [
	createGrammar := aGrammar
]

{ #category : #views }
GtLSmaCCParserCreationResult >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	parserClass asClassIfAbsent: [^ aView empty].
	^ aView explicit
		title: 'Parser class';
		priority: 10;
		stencil: [ | container |
			container := BrVerticalPane new
				matchParent;
				background: BrGlamorousColors backdropColor.
			container
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				addChild: ((GtCoderElement forClass: parserClass asClass)
						disablePlayPage;
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude).
			container ]
]

{ #category : #views }
GtLSmaCCParserCreationResult >> gtGrammarFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Grammar';
		priority: 1;
		object: [ createGrammar ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLSmaCCParserCreationResult >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCParserCreationResult >> parserClass: aClassName [
	parserClass := aClassName
]

{ #category : #magritte }
GtLSmaCCParserCreationResult >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Parser Class';
		accessor: #parserClass;
		beRequired
]

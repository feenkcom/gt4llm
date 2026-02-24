Class {
	#name : #GtLSmaCCParserReference,
	#superclass : #Object,
	#instVars : [
		'parserClass'
	],
	#category : 'Gt4Llm-SmaCC-Domain Objects'
}

{ #category : #'as yet unclassified' }
GtLSmaCCParserReference >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
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

{ #category : #accessing }
GtLSmaCCParserReference >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCParserReference >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCParserReference >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Parser Class';
		accessor: #parserClass;
		beRequired
]

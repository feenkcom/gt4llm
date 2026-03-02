Class {
	#name : #GtLSmaCCDefinition,
	#superclass : #Object,
	#instVars : [
		'definition',
		'parserClass',
		'scannerClass'
	],
	#category : #'Gt4Llm-SmaCC-Domain Objects'
}

{ #category : #accessing }
GtLSmaCCDefinition >> definition [
	^ definition
]

{ #category : #accessing }
GtLSmaCCDefinition >> definition: anObject [
	definition := anObject
]

{ #category : #accessing }
GtLSmaCCDefinition >> definitionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Parser Definition';
		accessor: #definition;
		beRequired
]

{ #category : #'as yet unclassified' }
GtLSmaCCDefinition >> gtClassCoderViewFor: aView [
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
GtLSmaCCDefinition >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtLSmaCCDefinition >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #accessing }
GtLSmaCCDefinition >> parserClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Parser Class';
		accessor: #parserClass;
		beOptional
]

{ #category : #accessing }
GtLSmaCCDefinition >> scannerClass [
	^ scannerClass
]

{ #category : #accessing }
GtLSmaCCDefinition >> scannerClass: anObject [
	scannerClass := anObject
]

{ #category : #accessing }
GtLSmaCCDefinition >> scannerClassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'SmaCC Scanner Class';
		accessor: #scannerClass;
		beOptional
]

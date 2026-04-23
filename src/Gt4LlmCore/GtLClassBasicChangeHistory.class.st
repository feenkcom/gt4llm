"
I am an abstract class for tracking class-level data changes (definition or comment).
"
Class {
	#name : #GtLClassBasicChangeHistory,
	#superclass : #GtLEntityChangeHistory,
	#instVars : [
		'targetClassName'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #testing }
GtLClassBasicChangeHistory >> existsInImage [ 
	self targetClassName asClassIfPresent: [ ^ true ].
	^ false
]

{ #category : #views }
GtLClassBasicChangeHistory >> gtClassCoderViewFor: aView [
	<gtView>
	<gtLlmView>
	<gtCodeChangeView>
	
	self existsInImage ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Current class';
		priority: 50;
		stencil: [ | container |
			container := BrVerticalPane new
					matchParent;
					background: BrGlamorousColors backdropColor.
			container
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				addChild: ((GtCoderElement forClass: self targetClassName asClass)
						disablePlayPage;
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude).
			container ]
]

{ #category : #accessing }
GtLClassBasicChangeHistory >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLClassBasicChangeHistory >> targetClassName: aString [
	targetClassName := aString
]

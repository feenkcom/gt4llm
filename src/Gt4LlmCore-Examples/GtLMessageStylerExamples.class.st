"
Examples for styling LLM messages with pragma annotations.
"
Class {
	#name : #GtLMessageStylerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMessageStylerExamples >> gtViewPragmaStyling [
	<gtExample>
	<return: #BlRopedText>
	| code text start end pragmaRange hasHide hasExpand hasButton |
	code := 'asdads 

{{gtPragma:gtView}}'.
	text := code asRopedText.
	GtLMessageStyler new
		style: text.
	start := code indexOfSubCollection: '{{gtPragma:gtView}}'.
	end := start + '{{gtPragma:gtView}}' size.
	pragmaRange := start to: end.
	hasHide := pragmaRange anySatisfy: [ :index | 
		(text attributesAt: index)
			anySatisfy: [ :attribute | attribute isKindOf: BrTextHideAttribute ] ].
	hasExpand := pragmaRange anySatisfy: [ :index | 
		(text attributesAt: index)
			anySatisfy: [ :attribute | attribute isKindOf: GtCachedTextExpandButtonAttribute ] ].
	hasButton := pragmaRange anySatisfy: [ :index | 
		(text attributesAt: index)
			anySatisfy: [ :attribute | attribute isKindOf: GtButtonAttribute ] ].
	self assert: hasHide.
	self assert: hasExpand not.
	self assert: hasButton.
	^ text
]

{ #category : #examples }
GtLMessageStylerExamples >> gtViewPragmaStylingWithoutFullName [
	<gtExample>
	<return: #BlRopedText>
	| code text start end pragmaRange hasHide hasExpand hasButton buttonColor buttonAttribute button |
	code := '123  

{{gtPragma:gtVi}}'.
	text := code asRopedText.
	GtLMessageStyler new style: text.
	start := code indexOfSubCollection: '{{gtPragma:gtVi}}'.
	end := start + '{{gtPragma:gtVi}}' size.
	pragmaRange := start to: end.
	hasHide := pragmaRange
			anySatisfy: [ :index | 
				(text attributesAt: index)
					anySatisfy: [ :attribute | attribute isKindOf: BrTextHideAttribute ] ].
	self assert: hasHide.
	hasExpand := pragmaRange
			anySatisfy: [ :index | 
				(text attributesAt: index)
					anySatisfy: [ :attribute | attribute isKindOf: GtCachedTextExpandButtonAttribute ] ].
	self assert: hasExpand not.
	buttonAttribute := (text attributesAt: start) detect: [ :a | a isKindOf: GtButtonAttribute ]
			ifNone: [ self assert: false ].
	button := (buttonAttribute instVarNamed: 'stencilBuilder') build.
	buttonColor := (button userData at: #brickLook) defaultColor.
	self assert: buttonColor equals: BrGlamorousColors linkWithErrorColor.
	^ text
]

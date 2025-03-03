Class {
	#name : #GtSharedStringAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'builder'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtSharedStringAttribute >> builder [
	^ builder
]

{ #category : #accessing }
GtSharedStringAttribute >> builder: anObject [
	builder := anObject
]

{ #category : #'as yet unclassified' }
GtSharedStringAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	^ GtSharedEditableLabel new
		aptitude: BrGlamorousEditableLabelAptitude new glamorousCodeFontAndSize;
		builder: self builder
]

{ #category : #'as yet unclassified' }
GtSharedStringAttribute >> initialize [
	super initialize.

	self beNotOverwritableByStyler.
	self beReplace.

	self cache: self newPooledCache
]

{ #category : #'as yet unclassified' }
GtSharedStringAttribute >> isFocusable [
	^ true
]

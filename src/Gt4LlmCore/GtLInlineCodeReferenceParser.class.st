Class {
	#name : #GtLInlineCodeReferenceParser,
	#superclass : #GtLInlineCodeReferenceGrammar,
	#instVars : [
		'styler'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #'instance creation' }
GtLInlineCodeReferenceParser class >> forStyler: aMessageStyler [
	^ self new
		styler: aMessageStyler;
		yourself
]

{ #category : #accessing }
GtLInlineCodeReferenceParser class >> ignoredNames [
	^ super ignoredNames , #(styler)
]

{ #category : #grammar }
GtLInlineCodeReferenceParser >> className [
	^ super className
		==> [ :name | 
			| global |
			global := Smalltalk at: name asSymbol ifAbsent: [ nil ].
			global isBehavior ifTrue: [ global ] ]
]

{ #category : #grammar }
GtLInlineCodeReferenceParser >> classReference [
	^ super classReference
		==> [ :behavior | 
			behavior
				ifNotNil: [ [ :codeText :appendButton | 
					appendButton
						value: (styler
								coderButtonAttributeWithLabel: [ behavior gtDisplayString ]
								valid: true
								withTool: [ GtClassCoderTool forClass: behavior ]) ] ] ]
]

{ #category : #grammar }
GtLInlineCodeReferenceParser >> methodReference [
	^ super methodReference
		==> [ :parts | 
			| behavior method |
			behavior := parts first.
			method := behavior
					ifNotNil: [ (parts second ifNil: [ behavior ] ifNotNil: [ behavior class ])
							lookupSelector: parts fourth ].
			method
				ifNil: [ [ :codeText :appendButton | 
					styler styleInlineSmalltalk: codeText source: codeText asString.
					false ] ]
				ifNotNil: [ [ :codeText :appendButton | 
					appendButton
						value: (styler
								coderButtonAttributeWithLabel: [ method gtDisplayString ]
								valid: true
								withTool: [ GtMethodCoderTool compiledMethod: method ]) ] ] ]
]

{ #category : #grammar }
GtLInlineCodeReferenceParser >> noise [
	^ super noise
		==> [ :source | 
			[ :codeText :appendButton | 
			styler styleInlineSmalltalk: codeText source: source.
			false ] ]
]

{ #category : #grammar }
GtLInlineCodeReferenceParser >> selector [
	^ super selector ==> #asSymbol
]

{ #category : #accessing }
GtLInlineCodeReferenceParser >> styler: aMessageStyler [
	styler := aMessageStyler
]

{ #category : #grammar }
GtLInlineCodeReferenceParser >> symbol [
	^ super symbol
		==> [ :name | [ :codeText :appendButton | appendButton value: (styler symbolButtonAttributeFor: name asSymbol) ] ]
]

Class {
	#name : #GtLInlineCodeReferenceParser,
	#superclass : #GtLInlineCodeReferenceGrammar,
	#instVars : [
		'styler',
		'existingFileReference'
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
GtLInlineCodeReferenceParser >> existingFileReference [
	^ super noise
		>=> [ :context :parse | 
			| position reference |
			position := context position.
			reference := self existingFileReferenceFor: parse value.
			reference
				ifNil: [ context position: position.
					PP2Failure message: 'existing file or directory expected' context: context ] ]
]

{ #category : #private }
GtLInlineCodeReferenceParser >> existingFileReferenceFor: source [
	| path reference |
	path := source trimBoth.
	path isEmpty ifTrue: [ ^ nil ].
	(path first = $~
		and: [ path size = 1
				or: [ path second = $/ or: [ path second = FileSystem disk delimiter ] ] ])
		ifTrue: [ path := path
					copyReplaceFrom: 1
					to: 1
					with: FileLocator home asFileReference fullName ].
	^ [ reference := path asFileReference.
	reference exists ifTrue: [ reference asAbsolute ] ]
		on: FileSystemError
		do: [ :error | nil ]
]

{ #category : #grammar }
GtLInlineCodeReferenceParser >> filePath [
	^ existingFileReference
		==> [ :reference | 
			[ :codeText :appendButton | 
			| label |
			label := codeText asString trimBoth.
			appendButton
				value: (styler
						coderButtonAttributeWithLabel: [ label ]
						valid: true
						withTool: [ GtInspectorTool forObject: reference ]) ] ]
]

{ #category : #grammar }
GtLInlineCodeReferenceParser >> methodReference [
	^ super methodReference
		==> [ :parts | 
			| behavior method |
			behavior := parts first.
			method := behavior
					ifNotNil: [ (parts second ifNil: [ behavior ] ifNotNil: [ behavior class ])
							compiledMethodAt: parts fourth
							ifAbsent: [ nil ] ].
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
GtLInlineCodeReferenceParser >> start [
	^ methodReference / self filePath / classReference / symbol / noise
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

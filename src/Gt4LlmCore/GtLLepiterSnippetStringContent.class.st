"
I am the content of a textual snippet: a copy of its `contentAsString`, which is `code` for a code snippet and `string` for a text snippet. I am also the content of an example snippet, whose `contentAsString` is its annotation, `{{gtExample:...}}`, and of an unknown snippet, as its JSON.

My `diffKind` tells how I am diffed:
- #code: Pharo splitter and code styler, for Pharo snippets;
- #text: by words, for text and example snippets;
- #lines: by lines, for the other code snippets (Python, shell, JavaScript, ...), unknown snippets, and the fallback of non-textual snippets whose properties cannot be written.

The other attributes of textual snippets (paragraph style, heights, ...) are not recorded.
"
Class {
	#name : #GtLLepiterSnippetStringContent,
	#superclass : #GtLLepiterSnippetContent,
	#instVars : [
		'string',
		'diffKind'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLLepiterSnippetStringContent class >> string: aString diffKind: aSymbol [
	"Keep a copy of aString (nil is the empty string): a snippet can answer its own string as contentAsString"

	^ self new
		string: (aString ifNil: [ '' ] ifNotNil: [ :anObject | anObject asString copy ]);
		diffKind: aSymbol;
		yourself
]

{ #category : #comparing }
GtLLepiterSnippetStringContent >> = anObject [
	^ super = anObject and: [ self diffKind = anObject diffKind ]
]

{ #category : #accessing }
GtLLepiterSnippetStringContent >> contentString [
	^ string ifNil: [ '' ]
]

{ #category : #accessing }
GtLLepiterSnippetStringContent >> diffKind [
	"#code, #text or #lines"

	^ diffKind ifNil: [ #lines ]
]

{ #category : #accessing }
GtLLepiterSnippetStringContent >> diffKind: aSymbol [
	diffKind := aSymbol
]

{ #category : #diff }
GtLLepiterSnippetStringContent >> diffSplitter [
	self diffKind = #code ifTrue: [ ^ GtSmaCCDiffSplitter forPharo ].
	self diffKind = #text ifTrue: [ ^ GtCharacterGroupDiffSplitter words ].
	^ GtLineDiffSplitter new
]

{ #category : #diff }
GtLLepiterSnippetStringContent >> diffStyler [
	^ self diffKind = #code ifTrue: [ GtCodeDiffRBTextStyler new ] ifFalse: [ nil ]
]

{ #category : #accessing }
GtLLepiterSnippetStringContent >> string [
	^ string
]

{ #category : #accessing }
GtLLepiterSnippetStringContent >> string: aString [
	string := aString
]

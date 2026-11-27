Class {
	#name : #GtLToolForLepiterSnippetsCreate,
	#superclass : #GtLAbstractLepiterTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #private }
GtLToolForLepiterSnippetsCreate >> createSnippetFrom: snippetArguments [
	"Add the snippet to the page, or to the parent snippet, and answer its addition result"

	| parentSnippetUidString parent snippet |
	(self missingArgumentAmong: #('pageUid') in: snippetArguments)
		ifNotNil: [ :aProblem | ^ aProblem ].
	^ snippetArguments
		validateSnippetArgumentsFor: self
		ifCorrect: [ parentSnippetUidString := snippetArguments parentSnippetUid
					ifNil: [ '' ]
					ifNotNil: [ :aString | aString asString trimBoth ].
			parentSnippetUidString isEmpty
				ifTrue: [ self snippetLocator
						pageWithUid: snippetArguments pageUid
						databaseId: snippetArguments databaseId
						ifFound: [ :aPage | parent := aPage ]
						ifNone: [ :aProblem | ^ aProblem ] ]
				ifFalse: [ self snippetLocator
						snippetWithUid: parentSnippetUidString
						pageUid: snippetArguments pageUid
						databaseId: snippetArguments databaseId
						ifFound: [ :aSnippet | parent := aSnippet ]
						ifNone: [ :aProblem | ^ aProblem ] ].
			[ snippet := snippetArguments buildSnippetFor: self.
			parent addSnippet: snippet ]
				on: Error
				do: [ :error | 
					^ GtLExceptionDomainObject new
						freeze: error;
						errorReason: 'Error while creating snippet' ].
			GtLLepiterSnippetAdditionResult new
				newSnippet: (GtLLepiterSnippetWithContent fromSnippet: snippet);
				yourself ]
]

{ #category : #accessing }
GtLToolForLepiterSnippetsCreate >> description [
	^ 'Adds snippets to Lepiter pages, in the given order. The key of each item is the snippet type. A snippet is added at the end of the page, or as the last child of parentSnippetUid.

The response has one entry per requested snippet, in order: the reference of the created snippet, or an errorMessage. When one fails, the others are still created.

Example JSON arguments:
{"snippets": [
  {"TextSnippet": {"pageUid": "86t968o90hlfreacjec76wapk", "snippetText": "Notes"}},
  {"PharoSnippet": {"pageUid": "86t968o90hlfreacjec76wapk", "parentSnippetUid": "SgJekENeTPytZjVknCfulw==", "pharoCode": "Transcript show: 1"}},
  {"ExampleSnippet": {"databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "86t968o90hlfreacjec76wapk", "exampleClassName": "MyExamples", "exampleMethodName": "exampleMethod"}},
  {"PictureSnippet": {"pageUid": "7h2k9w0x3m5n1p8q4r6s2t0u9", "urlString": "https://example.com/picture.png", "previewHeight": 200}}
]}

Example JSON response:
{"snippets": [
  {"status": "created", "targetSnippetReference": {"databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "86t968o90hlfreacjec76wapk", "snippetUid": "q7Tn0dVbRZ6uJ1cE4yHw2A=="}},
  {"status": "created", "targetSnippetReference": {"databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "86t968o90hlfreacjec76wapk", "snippetUid": "Xk3mZ0aQS8y1nV2pL7wR9g=="}},
  {"status": "created", "targetSnippetReference": {"databaseId": "dklrfmltzaib6womkfkknkfap", "pageUid": "86t968o90hlfreacjec76wapk", "snippetUid": "bb49pqTrTh+k1tAEnG4H4Q=="}},
  {"errorMessage": "Could not locate page with id 7h2k9w0x3m5n1p8q4r6s2t0u9"}
]}'
]

{ #category : #accessing }
GtLToolForLepiterSnippetsCreate >> name [
	^ 'createLepiterSnippets'
]

{ #category : #private }
GtLToolForLepiterSnippetsCreate >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	"The JSON schema and the Magritte reader make each element of snippets a creation request of the type its key names, so the elements need no type check"

	| results |
	results := (aToolCall arguments at: 'snippets')
			collect: [ :each | self createSnippetFrom: each ].
	^ GtLLepiterSnippetsChangeResult new
		snippetResults: results;
		yourself
]

{ #category : #private }
GtLToolForLepiterSnippetsCreate >> snippetClassForType: snippetType [
	| normalizedType |
	normalizedType := snippetType asString trimBoth.
	normalizedType isEmpty ifTrue: [ normalizedType := 'text' ].
	^ {
		'text' -> LeTextSnippet.
		'pharo' -> LePharoSnippet.
		'python' -> LePythonSnippet.
		'shell' -> LeShellScriptSnippet.
		'example' -> LeExampleSnippet.
		'picture' -> LePictureSnippet } asDictionary
			at: normalizedType
			ifAbsent: [ nil ]
]

{ #category : #magritte }
GtLToolForLepiterSnippetsCreate >> snippetsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Snippets';
		accessor: #snippets;
		classes: {
			GtLLepiterTextSnippetCreationRequest.
			GtLLepiterPharoSnippetCreationRequest.
			GtLLepiterPythonSnippetCreationRequest.
			GtLLepiterShellSnippetCreationRequest.
			GtLLepiterExampleSnippetCreationRequest.
			GtLLepiterPictureSnippetCreationRequest };
		useExplicitContainerForChildren;
		beRequired
]

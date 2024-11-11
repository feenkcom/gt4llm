Class {
	#name : #GtOpenAILepiterTextSnippetTutor,
	#superclass : #GtOpenAILepiterSnippetTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAILepiterTextSnippetTutor >> formatName [
	^ 'serialized Lepiter text snippet'
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterTextSnippetTutor >> gtCorrectGrammar [
 	<gtLlmTutorAction>
 	^ GtLlmTutorAction new
	    name: 'Correct grammar';
	    priority: 10;
		description: 'Correct the grammar of the text snippet in place.';
		examples: {}
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterTextSnippetTutor >> gtCreateTitle [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Create title';
		priority: 10;
		description: 'Create a title for the snippet inline as a heading. Do not use quotes of any kind. Be crisp.';
		examples: {}
]

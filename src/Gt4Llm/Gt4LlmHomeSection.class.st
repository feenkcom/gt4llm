Class {
	#name : #Gt4LlmHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#classVars : [
		'ShouldShowSection'
	],
	#category : #'Gt4Llm-World'
}

{ #category : #settings }
Gt4LlmHomeSection class >> hideSection [
	self shouldShowSection:  false.
	GtWorld requestAllInstancesHomeUpdate
]

{ #category : #settings }
Gt4LlmHomeSection class >> shouldShowSection [
	^ ShouldShowSection ifNil: [ false ]
]

{ #category : #settings }
Gt4LlmHomeSection class >> shouldShowSection: aBoolean [
	ShouldShowSection := aBoolean
]

{ #category : #settings }
Gt4LlmHomeSection class >> showSection [
	self shouldShowSection:  true.
	GtWorld requestAllInstancesHomeUpdate
]

{ #category : #accessing }
Gt4LlmHomeSection >> apiKeyCard [
	<gtSectionCard>
	| card |
	card := GtHomeCard explicit.
	^ card
		title: 'OpenAI API Key';
		description: 'Install an OpenAI API Key';
		priority: 11;
		stencil: [ BrVerticalPane new
				exact: 300 @ 250;
				background: Color white;
				aptitude: BrShadowAptitude new beLarge + (GtPhlowBrowseDefinitionAptitude new definition: [ card definingMethod ]);
				cellSpacing: 5;
				padding: (BlInsets all: 10);
				margin: (BlInsets
						top: self spaceGap
						left: 2 * self spaceGap
						bottom: 2 * self spaceGap
						right: 2 * self spaceGap);
				addChild: (BrLabel new
						beLargeSize;
						padding: (BlInsets
								top: 10
								left: 5
								bottom: 10
								right: 20);
						aptitude: BrGlamorousLabelAptitude new bold;
						text: 'Set an OpenAI API key');
				addChild: (BrEditor new
						padding: (BlInsets left: 6 right: 5);
						preventMeAndChildrenMouseEvents;
						aptitude: (BrGlamorousRegularEditorAptitude new foreground: Color black);
						text: 'For working with OpenAI you need an API key. Please point to a text file that has as contents the key for the OpenAI API.');
				addChild: (GtOpenAICardElement new hMatchParent margin: (BlInsets all: 5)) ]
]

{ #category : #accessing }
Gt4LlmHomeSection >> lepiterCard [
	<gtSectionCard>
	^ GtHomeCard lepiterBaseWithTableOfContents
		title: 'Glamorous Toolkit for large language models (LLMs)';
		description: 'Read the docs';
		priority: 10;
		pageName: 'Glamorous Toolkit for large language models (LLMs)';
		databaseName: 'gt4llm-lepiter';
		details: [ :db | 
			'This knowledge base documents the interactions with various LLMs.' ]
]

{ #category : #accessing }
Gt4LlmHomeSection >> sectionTitle [
	^ 'Glamorous Toolkit for Large Language Models'
]

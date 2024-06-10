Class {
	#name : #Gt4LlmHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #Gt4Llm
}

{ #category : #accessing }
Gt4LlmHomeSection >> apiKeyCard [
	<gtSectionCard>
	^ GtHomeCard explicit
		title: 'OpenAI API Key';
		description: 'Install an OpenAI API Key';
		priority: 10;
		stencil: [ BrVerticalPane new
				exact: 500@250;
				background: Color white;
				aptitude: BrShadowAptitude new beLarge;
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
				addChild: (GtOpenAICardElement new margin: (BlInsets all: 5)) ]
]

{ #category : #accessing }
Gt4LlmHomeSection >> lepiterCard [
	<gtSectionCard>
	^ GtHomeCard lepiterBaseWithTableOfContents
		title: 'Glamorous Toolkit for LLMs';
		description: 'Read the docs';
		priority: 10;
		pageName: 'Glamorous Toolkit for LLMs';
		databaseName: 'gt4llm-lepiter';
		details: [ :db | 
			'This knowledge base documents the interactions with various LLMs.' ]
]

{ #category : #accessing }
Gt4LlmHomeSection >> sectionTitle [
	^ 'Glamorous Toolkit for Large Language Models'
]

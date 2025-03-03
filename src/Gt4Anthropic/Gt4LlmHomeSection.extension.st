Extension { #name : #Gt4LlmHomeSection }

{ #category : #'*Gt4Anthropic' }
Gt4LlmHomeSection >> anthropicApiKeyCard [
	<gtSectionCard>
	| card |
	card := GtHomeCard explicit.
	^ card
		title: 'Anthropic API Key';
		description: 'Install an Anthropic API Key';
		priority: 11;
		stencil: [ BrVerticalPane new
				exact: 400 @ 250;
				background: Color white;
				aptitude: BrShadowAptitude new beLarge
						+ (GtPhlowBrowseDefinitionAptitude new definition: [ card definingMethod ]);
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
						text: 'Set an Anthropic API key');
				addChild: (BrEditor new
						padding: (BlInsets left: 6 right: 5);
						preventMeAndChildrenMouseEvents;
						aptitude: (BrGlamorousRegularEditorAptitude new foreground: Color black);
						text: 'For working with Anthropic you need an API key. Please point to a text file that has as contents the key for the Anthropic API.');
				addChild: (GtLlmApiKeyCardElement new hMatchParent
						clientClass: GtAnthropicClient;
						margin: (BlInsets all: 5)) ]
]

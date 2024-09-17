Class {
	#name : #GtOpenAIWardleyMapActionTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAIWardleyMapActionAssistantChat new
			assistant: self assistant;
			tutor: self;
			actions: actions;
			responseFormat: self format asJsonSchema;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> connectionAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Add new connected nodes';
		priority: 2;
		description: 'Adds new nodes that are connected to an already existing node. It MUST consider the context of the map topic. It MUST return the entirety of the state.';
		format: 'Add new connected nodes to `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Add new connected nodes to `Compute`'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]

'} asDictionary;
					output: {'Action' -> 'Add new connected nodes'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]
component Platform [0.73, 0.71] label [-26, 29]
component Cloud [0.9, 0.81] label [-26, 29]

Compute->Platform
Compute->Cloud'.
							'Text' -> nil.
							'Rename' -> nil} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Add new connected nodes to `Regulator`'.
							'Topic' -> 'Regulation'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Regulator [0.6, 0.2] label [-22, 29]
'} asDictionary;
					output: {'Action' -> 'Add new connected nodes'.
							'Topic' -> 'Regulation'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Regulator [0.6, 0.2] label [-22, 29]
component Audit [0.8, 0.8] label [-26, 29]

Regulator->Audit
'.
							'Text' -> nil.
							'Rename' -> nil} asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> explanationAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain a node';
		priority: 3;
		description: 'Explains what a node means and why it is on the map using human language.';
		format: 'Explain the node `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Explain `Compute`'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.4, 0.4] label [-22, 29]'} asDictionary;
					output: {'Action' -> 'Explain a node'.
							'Text'
								-> 'In the context of this Wardley Map on Cloud Computing, the node `Compute` refers to the computing resources and capabilities provided as part of cloud services. This encompasses the virtualized processing power (CPUs, GPUs) that can be scaled up or down on demand to meet the needs of applications or services running in the cloud. The `Compute` node is fundamental to cloud computing, as it allows for flexible, efficient, and scalable computing solutions that can be tailored to the specific requirements of businesses and developers.

The presence of `Compute` in a cloud computing map highlights its role as a core component of the cloud value chain, directly supporting various higher-level services and applications that depend on reliable and scalable computing resources. It could be connected to nodes representing services that leverage these computing resources, such as web hosting, data analytics platforms, or any software-as-a-service (SaaS) applications, indicating a dependency relationship where these services rely on the underlying compute capabilities to function effectively.

In summary, `Compute` signifies the provisioning of raw processing power in the cloud, which is pivotal to the delivery of a wide range of cloud-based services and applications, illustrating the utility and flexibility offered by cloud computing paradigms.'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.4, 0.4] label [-22, 29]'.
							'Rename' -> nil} asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> formatName [
	^ 'Wardley Map'
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initialAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Create a set of nodes';
		priority: 1;
		description: 'Creates a set of at least 20 nodes based on a given topic, filling topic, nodes, and connections with sensible data. If a map topic was already set, it is overridden. The rest of the map is extended.';
		format: 'Create a set of nodes on {1}';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Create a set of nodes on Moldable development'.
							'Wardley Map'
								-> 'style wardley\n\nevolution genesis -> custom built -> product (+rental) -> commodity\n\n\n'}
							asDictionary;
					output: {'Action' -> 'Create a set of nodes on Moldable development'.
							'Topic' -> 'Moldable development'.
							'Rename' -> nil.
							'Text' -> nil.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Moldable Development [0.34, 0.37]
component Prototyping Tools [0.21, 0.44]
component Customization Layer [0.4, 0.5]
component User Interface [0.58, 0.61]
component Integration APIs [0.51, 0.79]
component Domain-Specific Languages [0.35, 0.42]
component Agile Methodologies [0.64, 0.2]
component Continuous Integration [0.8, 0.21]
component Testing Frameworks [0.72, 0.38]
component Cloud Deployment [0.97, 0.66]
component Data Storage [0.85, 0.8]
component Security Layers [0.6, 0.81]
component Automated Testing [0.73, 0.51]
component Feedback Systems [0.58, 0.93]
component End-User Programming [0.44, 0.48]
component Component Libraries [0.61, 0.42]
component Visual Programming [0.23, 0.65]
component Adaptive User Experience [0.31, 0.72]
component Domain Modeling [0.54, 0.57]
component User-Centric Design [0.48, 0.89]

Moldable Development->Prototyping Tools
Moldable Development->Customization Layer
Moldable Development->Integration APIs
User Interface->Customization Layer
Integration APIs->Cloud Deployment
Cloud Deployment->Data Storage
Agile Methodologies->Continuous Integration
Continuous Integration->Testing Frameworks
Testing Frameworks->Automated Testing
Automated Testing->Feedback Systems
Domain-Specific Languages->Domain Modeling
Domain Modeling->User-Centric Design
Component Libraries->Visual Programming
Visual Programming->Adaptive User Experience
End-User Programming->Domain-Specific Languages
Security Layers->Data Storage
Security Layers->Cloud Deployment
Adaptive User Experience->User-Centric Design
Feedback Systems->User Interface
Data Storage->Custom Layer
Continuous Integration->Cloud Deployment

'}
							asDictionary.
				GtLlmTutorActionExample new
					input: {'Action'
								-> 'Create a set of nodes on Key components for a drone delivery service'.
							'Wardley Map'
								-> 'style wardley\n\nevolution genesis -> custom built -> product (+rental) -> commodity\n\n\n'}
							asDictionary;
					output: {'Rename' -> nil.
							'Action'
								-> 'Create a set of nodes on Key components for a drone delivery service'.
							'Topic' -> 'Key components for a drone delivery service'.
							'Wardley Map'
								-> 'style wardley\n\nevolution genesis -> custom built -> product (+rental) -> commodity\n\ncomponent Drone Fleet [0.4, 0.3]\ncomponent Navigation System [0.5, 0.6]\ncomponent Ground Control [0.3, 0.5]\ncomponent Delivery Software [0.6, 0.7]\ncomponent Customer Interface [0.7, 0.8]\ncomponent Package Handling [0.4, 0.7]\ncomponent Battery Management [0.5, 0.4]\ncomponent Weather Monitoring [0.6, 0.5]\ncomponent Traffic Management [0.5, 0.8]\ncomponent Regulatory Compliance [0.7, 0.3]\ncomponent Communication Network [0.6, 0.6]\ncomponent Data Analytics [0.8, 0.7]\ncomponent Maintenance Services [0.3, 0.4]\ncomponent Drone Manufacturing [0.2, 0.3]\ncomponent Emergency Response System [0.6, 0.4]\ncomponent Fleet Management Software [0.8, 0.5]\ncomponent Mapping Services [0.7, 0.6]\ncomponent Security Protocols [0.5, 0.3]\ncomponent Automated Scheduling [0.6, 0.9]\ncomponent User Feedback System [0.7, 0.9]\n\nDrone Fleet->Navigation System\nDrone Fleet->Battery Management\nNavigation System->Ground Control\nGround Control->Traffic Management\nDelivery Software->Customer Interface\nCustomer Interface->User Feedback System\nPackage Handling->Drone Fleet\nBattery Management->Emergency Response System\nWeather Monitoring->Navigation System\nTraffic Management->Regulatory Compliance\nRegulatory Compliance->Security Protocols\nCommunication Network->Data Analytics\nData Analytics->Automated Scheduling\nMaintenance Services->Drone Manufacturing\nDrone Manufacturing->Fleet Management Software\nEmergency Response System->Fleet Management Software\nFleet Management Software->Mapping Services\nMapping Services->Security Protocols\nAutomated Scheduling->Delivery Software\nUser Feedback System->Delivery Software\n\n'.
							'Text' -> nil} asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initialize [
	super initialize.

	self initializePipeline
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initializePipeline [
	self
		pipelineBuilder: [ GtLlmContext new
				instance: GtLlmActionWardleyMapCreator new;
				isImmutableInstance: true;
				checker: (GtLlmAlternativeCodeStep new
						addAlternative: (GtLlmCompositeCodeStep new
									addStep: GtLlmValueExtractorCodeStep new;
									addStep: GtLlmWardleyMapTopicStep new)
							matching: [ :aContext | aContext lastResult key = 'Topic' ];
						addAlternative: (GtLlmCompositeCodeStep new
									addStep: GtLlmValueExtractorCodeStep new;
									addStep: GtLlmWardleyMapMapStep new)
							matching: [ :aContext | aContext lastResult key = 'Wardley Map' ];
						addAlternative: (GtLlmCompositeCodeStep new
									addStep: GtLlmValueExtractorCodeStep new;
									addStep: GtLlmWardleyMapRenameStep new)
							matching: [ :aContext | aContext lastResult key = 'Rename' ];
						addAlternative: (GtLlmCompositeCodeStep new
									addStep: GtLlmValueExtractorCodeStep new;
									addStep: GtLlmWardleyMapExplanationStep new)
							matching: [ :aContext | aContext lastResult key = 'Explanation' ]) ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> mapFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Wardley Map';
		priority: 2;
		format: 'Wardley Map language';
		example: '```
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Hello [0.80, 0.20] label [-14, 29]

component Goodbye [0.40, 0.60] label [-22, 29]

component Hello again! [0.60, 0.80] label [-42, 29]


Hello->Goodbye
Goodbye->Hello again!
```'
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> renameAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for node';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for nodes (less than ten, but more than one).';
		format: 'Propose renames for node `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for node `Compute`'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'} asDictionary;
					output: {'Action' -> 'Propose renames for node'.
							'Topic' -> 'Cloud computing'.
							'Text' -> nil.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'.
							'Rename' -> '{''Compute'': [''Computational resources'', ''Resources'']}'}
							asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for node `Furnace`'.
							'Topic' -> 'Appliances'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Furnace [0.9, 0.9] label [-9, 9]'} asDictionary;
					output: {'Action' -> 'Propose renames for node'.
							'Rename'
								-> '{''Furnace'': [''Boiler'', ''Heater'', ''Incinerator'', ''Kiln'', ''Stove'']}'.
							'Topic' -> 'Appliances'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Furnace [0.9, 0.9] label [-9, 9]'.
							'Text' -> nil} asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> renameFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Rename';
		priority: 2;
		format: 'Text';
		example: '```
{''Node name'': [''Proposal A'', ''Proposal B'']}
```'
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> reviewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Review the current state';
		priority: 5;
		description: 'Reviews and criticizes the current state of the map.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Review the current state'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'} asDictionary;
					output: {'Text'
								-> 'The map is incomplete. Currently, only one node is defined. A complete map should have multiple nodes and connections. The current node `Compute` is correct, but misplaced.'.
							'Action' -> 'Review the current state'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'.
							'Rename' -> nil} asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> topicFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Topic';
		priority: 1;
		format: 'Text';
		example: '```topic
Cloud computing in regulated areas
```'
]

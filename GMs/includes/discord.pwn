#include <YSI_Coding\y_hooks>

hook OnGameModeInit()
{
	print("[DCC] Connecting to Discord...");
	return 1;
}

SendDiscordMessage(channel, const message[])
{
	if(betaserver == 0) {
		switch(channel)
		{
			// #admin
			case 0:
			{
				g_AdminChannelId = DCC_FindChannelById("1416319327308873859");
				DCC_SendChannelMessage(g_AdminChannelId, message);
			}
			// #admin-warnings
			case 1:
			{
				g_AdminWarningsChannelId = DCC_FindChannelById("1416319349257670696");
				DCC_SendChannelMessage(g_AdminWarningsChannelId, message);
			}
			// #headadmin
			case 2:
			{
				g_HeadAdminChannelId = DCC_FindChannelById("1416319363895791627");
				DCC_SendChannelMessage(g_HeadAdminChannelId, message);
			}
			// #server-errors
			case 3:
			{
				g_ServerErrorsChannelId = DCC_FindChannelById("1416319377925476353");
				DCC_SendChannelMessage(g_ServerErrorsChannelId, message);
			}
		}
	} else {
		switch(channel)
		{
			// #server-errors
			case 3:
			{
				g_ServerErrorsChannelId = DCC_FindChannelById("1416319377925476353");
				DCC_SendChannelMessage(g_ServerErrorsChannelId, message);
			}
			default: {}
		}
	}
	return 1;
}

public DCC_OnMessageCreate(DCC_Message:message)
{
	if (betaserver == 0)
	{
		new DCC_Channel:channel;
		DCC_GetMessageChannel(message, channel);
		
		new DCC_User:author;
		DCC_GetMessageAuthor(message, author);
		
		new author_name[DCC_USERNAME_SIZE], content[512], channel_name[32], szMessage[128];
		DCC_GetUserName(author, author_name, sizeof(author_name));
		DCC_GetMessageContent(message, content, sizeof(content));
		DCC_GetChannelName(channel, channel_name, sizeof(channel_name));
		
		printf("[DCC] OnMessageCreate (Channel %s): Author %s sent message: %s", channel_name, author_name, content);
		
		if(!strcmp(channel_name, "admin", true) && strcmp(author_name, "NGGR Botnet", true))
		{
			format(szMessage, sizeof(szMessage), "* [Discord] Administrator %s: %s", author_name, content);
			ABroadCast(COLOR_YELLOW, szMessage, 2, true, true);
		}
		else if(!strcmp(channel_name, "headadmin", true) && strcmp(author_name, "NGGR Botnet", true))
		{
			format(szMessage, sizeof(szMessage), "(PRIVATE) [Discord] Administrator %s: %s", author_name, content);
			ABroadCast(COLOR_GREEN, szMessage, 1337, true, true);
		}
	}
	return 1;
}
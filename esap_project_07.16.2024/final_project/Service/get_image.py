from final_project.DAO.openai_interface import illustration


async def get_image(card_name):
    return illustration(card_name)

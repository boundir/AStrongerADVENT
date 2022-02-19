class X2Helper_ASA_Items extends Object;

static function AdjustWeaponDamage(Name WeaponTemplateName, WeaponDamageValue WeaponDamage)
{
    local X2ItemTemplateManager ItemTemplateManager;
    local X2WeaponTemplate WeaponTemplate;
    local array<X2DataTemplate> TemplateAllDifficulties;
    local X2DataTemplate Template;
        
    ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    ItemTemplateManager.FindDataTemplateAllDifficulties(WeaponTemplateName, TemplateAllDifficulties);

    foreach TemplateAllDifficulties(Template) 
    {
        WeaponTemplate = X2WeaponTemplate(Template);

        if(WeaponTemplate != none)
        {
            WeaponTemplate.BaseDamage = WeaponDamage;
        }
    }
}
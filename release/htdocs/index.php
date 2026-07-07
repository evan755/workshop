<?php declare(strict_types=1);

class WorkShop
{
    public string $name;
    public string $version;
    public string $description;
    public array $authors;
    public array $extensions;

    public function __construct()
    {
        $this->name = "WorkShop";
        $this->version = "1.0.0";
        $this->description = "PHP WorkShop";
        $this->authors = [
            [
                'name' => 'Evan',
                'email' => 'info@wupeize.com'
            ]
        ];
        $this->extensions = get_loaded_extensions();
    }

    public function main(): void
    {
        header("Content-type: application/json; charset=utf-8");
        echo json_encode($this);
    }
}

new WorkShop()->main();